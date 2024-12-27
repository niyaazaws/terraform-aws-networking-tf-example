/*
We have created a resource vpc in our template VPC
we are creating a VPC, therefore we need to configure it with a cidr_block and name
NOTE: everytime you create a variable you must create the corresponding resource/module
*/

variable "vpc_config" {
  type = object({
    cidr_block = string
    name       = string
  })

  /*
Here we are inclduing a validation check to ensure the data entered is adequate
*/
  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "THIS IS AN ERROR MESSAGE  -  must contain a valid CIDR range"
  }
}

/* we need to create subnets for the vpc so we configure the subnets
mapping the object allows user to create mulitples; in this case multiple subnets
NOTE: everytime you create a variable you must create the corresponding resource/module
*/
variable "subnet_config" {
  type = map(object({
    cidr_block = string
    az         = string
    public     = optional(bool, false)
  }))

  /* because this is mulitple we need an all function in this instance = alltrue
*/
  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "THIS IS AN ERROR MESSAGE  -  must contain a valid CIDR range"
  }
}