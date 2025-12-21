{
  buildHomeAssistantComponent,
  foxessModbusSrc,
}:
buildHomeAssistantComponent {
  owner = "nathanmarlor";
  domain = "foxess_modbus";
  version = foxessModbusSrc.shortRev;

  src = foxessModbusSrc;
}
