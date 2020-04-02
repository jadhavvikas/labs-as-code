import argparse
import json
import sys
from jinja2 import Template


def main():
    prog = 'python -m create-inventory'
    description = ('Generate an Ansible inventory from Terraform output variables.')
    parser = argparse.ArgumentParser(prog=prog, description=description)
    parser.add_argument("jinja2_template", nargs='?',
                        type=argparse.FileType('r', encoding="utf-8"),
                        help="the Jinja2 Ansible inventory file template",
                        default="hosts.j2")
    parser.add_argument("terraform_output", nargs='?',
                        type=argparse.FileType('r', encoding="utf-8"),
                        help="the 'terraform output --json' data",
                        default=sys.stdin)
    parser.add_argument("ansible_inventory", nargs='?',
                        type=argparse.FileType('w', encoding="utf-8"),
                        help="the resulting Ansible inventory file",
                        default=sys.stdout)

    args = parser.parse_args()

    j2_template = args.jinja2_template
    tf_output = args.terraform_output
    inventory_file = args.ansible_inventory
    with tf_output, inventory_file, j2_template:
        inventory_template = Template(j2_template.read(),
                                      keep_trailing_newline=True)
        tf_output_values = dict((k, v['value']) for (k, v) in json.load(tf_output).items())
        inventory_file.write(inventory_template.render(tf_output_values))


if __name__ == '__main__':
    main()

