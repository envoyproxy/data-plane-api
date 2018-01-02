#!/usr/bin/env python

import argparse
import fileinput
import re
import os
import os.path
import sys

EXCLUDED_PREFIXES = ("./generated/", "./bazel-", "./bazel/external")
SUFFIXES = (".cc", ".h", "BUILD", ".proto", ".md", ".rst")
DOCS_SUFFIX = (".md", ".rst")

CLANG_FORMAT_PATH = os.getenv("CLANG_FORMAT", "clang-format-5.0")
BUILDIFIER_PATH = os.getenv("BUILDIFIER", "/usr/lib/go/bin/buildifier")

found_error = False


def printError(error):
  global found_error
  found_error = True
  print "ERROR: %s" % (error)


def isBuildFile(file_path):
  basename = os.path.basename(file_path)
  if basename in {"BUILD", "BUILD.bazel"} or basename.endswith(".BUILD"):
    return True
  return False


def checkFileContents(file_path):
  with open(file_path) as f:
    text = f.read()
    if (re.search('[^.]\.  ', text, re.MULTILINE) or
        re.search(' $', text, re.MULTILINE)):
      printError("%s has over-enthusiastic spaces" % file_path)
      return False
  return True


def fixFileContents(file_path):
  regex = re.compile('([^.])\.  ')
  for line in fileinput.input(file_path, inplace=True):
    # Strip double space after '.'  This may prove overenthusiastic and need to
    # be restricted to comments and metadata files but works for now.
    print "%s" % regex.sub(r'\1. ', line).rstrip()


def checkFilePath(file_path):
  if isBuildFile(file_path):
    if os.system("cat %s | %s -mode=fix | diff -q %s - > /dev/null" %
                 (file_path, BUILDIFIER_PATH, file_path)) != 0:
      printError("buildifier check failed for file: %s" % file_path)
    return
  checkFileContents(file_path)

  if file_path.endswith(DOCS_SUFFIX):
    return
  command = ("%s %s | diff -q %s - > /dev/null" % (CLANG_FORMAT_PATH, file_path,
                                                   file_path))
  if os.system(command) != 0:
    printError("clang-format check failed for file: %s" % (file_path))


def fixFilePath(file_path):
  if isBuildFile(file_path):
    if os.system("%s -mode=fix %s" % (BUILDIFIER_PATH, file_path)) != 0:
      printError("buildifier rewrite failed for file: %s" % file_path)
    return
  fixFileContents(file_path)
  if file_path.endswith(DOCS_SUFFIX):
    return
  command = "%s -i %s" % (CLANG_FORMAT_PATH, file_path)
  if os.system(command) != 0:
    printError("clang-format rewrite error: %s" % (file_path))


def checkFormat(file_path):
  if file_path.startswith(EXCLUDED_PREFIXES):
    return

  if not file_path.endswith(SUFFIXES):
    return

  if operation_type == "check":
    checkFilePath(file_path)

  if operation_type == "fix":
    fixFilePath(file_path)


def checkFormatVisitor(arg, dir_name, names):
  for file_name in names:
    checkFormat(dir_name + "/" + file_name)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='Check or fix file format.')
  parser.add_argument('operation_type', type=str, choices=['check', 'fix'],
                      help="specify if the run should 'check' or 'fix' format.")
  parser.add_argument('target_path', type=str, nargs="?", default=".", help="specify the root directory"
                                                                            " for the script to recurse over. Default '.'.")
  parser.add_argument('--add-excluded-prefixes', type=str, nargs="+", help="exclude additional prefixes.")
  args = parser.parse_args()

  operation_type = args.operation_type
  target_path = args.target_path
  if args.add_excluded_prefixes:
    EXCLUDED_PREFIXES += tuple(args.add_excluded_prefixes)

  if os.path.isfile(target_path):
    checkFormat("./" + target_path)
  else:
    os.chdir(target_path)
    os.path.walk(".", checkFormatVisitor, None)

  if found_error:
    print "ERROR: check format failed. run 'tools/check_format.py fix'"
    sys.exit(1)
