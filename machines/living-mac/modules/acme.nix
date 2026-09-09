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

  services.nginx.commonHttpConfig = ''
    ssl_early_data on;
    add_header Alt-Svc 'h3=":443"; ma=86400' always;
    add_header_inherit merge;
  '';
}
