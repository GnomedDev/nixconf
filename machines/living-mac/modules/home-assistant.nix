# Required stateful files:
# /var/certs contains HTTPS certificates
# /var/predbat/apps.yaml is the predbat configuration with secrets
{
  pkgs,
  foxessModbusSrc,
  powerFlowCardSrc,
  jninja2TemplateSrc,
  ...
}:
{
  services.home-assistant = {
    enable = true;
    customComponents = [
      (pkgs.callPackage ../packages/foxess_modbus.nix { inherit foxessModbusSrc; })
    ];
    customLovelaceModules = [
      (pkgs.callPackage ../packages/power_flow_card_plus.nix { inherit powerFlowCardSrc; })
      (pkgs.callPackage ../packages/html_template_card.nix { inherit jninja2TemplateSrc; })
    ];
    extraComponents = [
      # Defaults
      "default_config"
      "radio_browser"
      "met"

      # Things we actually want.
      "weatherflow"
      "systemmonitor"
      "qbittorrent"

      # Performance optimisation
      "isal"
    ];
    config = {
      default_config = { };

      http = {
        ssl_certificate = "/var/certs/living-mac.tail272b81.ts.net.crt";
        ssl_key = "/var/certs/living-mac.tail272b81.ts.net.key";
      };

      homeassistant.packages.predbat_conv = {
        input_number = {
          force_charge_power_w = {
            name = "Force Charge Power (watts)";
            min = 0;
            max = 6000;
            step = 1;
            unit_of_measurement = "W";
          };
          force_discharge_power_w = {
            name = "Force Discharge Power (watts)";
            min = 0;
            max = 6000;
            step = 1;
            unit_of_measurement = "W";
          };
        };
        automation = [
          {
            alias = "Living Mac Battery Notification";
            id = "living_mac_battery_notification";
            triggers = [
              {
                trigger = "numeric_state";
                entity_id = [ "sensor.battery" ];
                below = 50;
              }
            ];
            actions = [
              {
                action = "notify.notify";
                metadata = { };
                data = {
                  title = "Living Mac Battery Low!";
                  message = "Living Room Macbook's battery level has dropped below 50%";
                };
              }
            ];
          }
          {
            alias = "Force Charge Power Translator";
            id = "force_charge_power_translator";
            triggers = [
              {
                trigger = "state";
                entity_id = "input_number.force_charge_power_w";
              }
            ];
            actions = {
              service = "number.set_value";
              target = {
                entity_id = "number.force_charge_power";
              };
              data = {
                value = "{{ states('input_number.force_charge_power_w')|float / 1000 }}";
              };
            };
          }
          {
            alias = "Force Disharge Power Translator";
            id = "force_discharge_power_translator";
            triggers = [
              {
                trigger = "state";
                entity_id = "input_number.force_discharge_power_w";
              }
            ];
            actions = {
              service = "number.set_value";
              target = {
                entity_id = "number.force_discharge_power";
              };
              data = {
                value = "{{ states('input_number.force_discharge_power_w')|float / 1000 }}";
              };
            };
          }
        ];
        template = [
          {
            sensor = [
              {
                device_class = "ENERGY";
                unique_id = "foxess_bms_kwh_remaining";
                unit_of_measurement = "kWh";
                default_entity_id = "sensor.bms_actual_kwh_remaining";
                availability = "{{ states('sensor.bms_kwh_remaining')|float(default=0) > 0 and states('sensor.battery_soc')|float(default=0) > 0 }}";
                name = "BMS kWh Remaining (SOH)";
                state = ''
                  {%- set bms_kwh_remaining = states('sensor.bms_kwh_remaining')|float(default=0)  %}
                  {%- set battery_soc = states('sensor.battery_soc')|float(default=0) %}
                  {{ (bms_kwh_remaining * battery_soc / 100)|round(3,"floor",0) }}
                '';
              }
              {
                device_class = "POWER";
                unique_id = "foxess_grid_ct_w";
                unit_of_measurement = "W";
                default_entity_id = "sensor.grid_ct_w";
                name = "Grid CT (Watts)";
                state = "{{ (states('sensor.grid_ct') | float(0)) * 1000 }}";
              }
              {
                device_class = "POWER";
                unique_id = "foxess_load_power_w";
                unit_of_measurement = "W";
                default_entity_id = "sensor.load_power_w";
                name = "Load Power (Watts)";
                state = "{{ (states('sensor.load_power') | float(0)) * 1000 }}";
              }
              {
                device_class = "POWER";
                unique_id = "foxess_pv_power_w";
                unit_of_measurement = "W";
                default_entity_id = "sensor.pv_power_w";
                name = "PV Power (Watts)";
                state = "{{ (states('sensor.pv_power') | float(0)) * 1000 }}";
              }
            ];
          }
        ];
      };
    };
  };

  virtualisation.oci-containers.containers.predbat = {
    image = "nipar44/predbat_addon:latest";
    extraOptions = [ "--network=host" ];
    ports = [ "5052" ];
    volumes = [
      "/var/predbat/apps.yaml:/config/apps.yaml:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
