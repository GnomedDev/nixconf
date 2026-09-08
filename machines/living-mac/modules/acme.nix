{ config, ... }: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "daisy2005thomas@gmail.com";
    certs."t4t.fail" = {
      domain = "*.t4t.fail";
      dnsProvider = "porkbun";
      environmentFile = "/var/certs/porkbun.secret";
      group = config.services.nginx.group;
    };
  };
}
