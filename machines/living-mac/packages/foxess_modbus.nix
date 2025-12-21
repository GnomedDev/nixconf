{
  buildHomeAssistantComponent,
  foxessModbusSrc,
}:
buildHomeAssistantComponent {
  owner = "nathanmarlor";
  domain = "foxess_modbus";

  src = foxessModbusSrc;
}
