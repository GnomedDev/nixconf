import json
import subprocess

list_cmd = ["nix", "eval", ".#nixosConfigurations", "--json", "--apply", "builtins.attrNames"]
result = subprocess.run(list_cmd, stdout=subprocess.PIPE)
result.check_returncode()

hostname_mapping = {
    "vm-aarch64-linux": "orb",
}

machines: list[str] = [
    machine
    for machine in json.loads(result.stdout)
    if not (machine.endswith("initial") or machine.endswith("setup") or machine.startswith("vm-"))
]

build_cmd = ["nix", "build", "--no-link", *[f".#nixosConfigurations.{machine}.config.system.build.vm" for machine in machines]]
subprocess.run(build_cmd).check_returncode()

for machine in machines:
    deploy_cmd = [
        "nix", "run", "nixpkgs#nixos-rebuild", "--",
        "--no-reexec", "--use-substitutes",
        "boot"
        "--target-host", f"root@{machine}",
        "--flake", f".#{machine}",
    ]

    if subprocess.run(build_cmd).returncode:
        print(f"\n-- Failed to deploy {machine}, skipping --\n")
