{ ... }:

{
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD7+KKrHWU5W3z5JGwVjT4BGXuDEPjlJoSWGzysEeyJzltuHK74z98CQn+kupkuLo5mXrInS92iIrwhsktBPW4sBlqWmL+Um89UerdCCMZeuXEZ6GLugQpniwhMYZ55x09rRd6pGJz5Babf5QfSi8gt3PQDwBHmx5s46ffSZhbzvX1XSWW8/xTpIn5EcpJYxzEYh+/EiVRzPmMXs+aexzRwTpQJkzL5niO3ok95f59oTDDgKMykdASQ8u9hrattr24psqO2S7DoeoFd+PCHKI4SYf+MDXucK+hNdb1+VtAyvmSc5q9NHH5TMXosRGGAIK7nnPacjEZPuM74SggONUEW05pMonLSwfWXtehSF6I89HF7FhjZxljgnUItFjyN3nbdaU1Vor4EyYYvfEKa9QUWUpA2Y/qaQliCSDao+u+ibRDE8+rR+ZhV6BvFDdrSmXzfCwhSH7QasHdTfekhRWu9swgogR6PULh5yoNpcB1L8fDrQTx3g8rg1+1V9apVKXM="
  ];
}
