{
  buildHomeAssistantComponent,
  foxessModbusSrc,
  home-assistant,
}:
buildHomeAssistantComponent {
  owner = "nathanmarlor";
  domain = "foxess_modbus";
  version = foxessModbusSrc.shortRev;

  src = foxessModbusSrc;
  dependencies = [ home-assistant.python3Packages.pyserial ];
}
