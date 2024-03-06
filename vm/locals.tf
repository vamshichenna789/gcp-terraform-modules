locals {
  labels = {
    for key, value in var.label_definitions : key => value
  }
}

