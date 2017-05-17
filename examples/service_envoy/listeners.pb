listeners {
  address {
    named_address {
      protocol: TCP
      port {
        value: 80
      }
    }
  }
  filter_chains {
    filter_chain {
      type: READ
      name: "http_connection_manager"
    }
  }
}
