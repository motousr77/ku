TEST GitHub -> Slack !!!

You just have to enter the command:

source ~/.bashrc

or you can use the shorter version of the command:

. ~/.bashrc

---

Use for get info about taints on nodes:

kubectl get nodes -o json | jq '.items[].spec'

which will give the complete spec with node name, or:

kubectl get nodes -o json | jq '.items[].spec.taints'

will produce the list of the taints per each node.

---

kubectl taint nodes <node_name> key=value:NoSchedule

kubectl taint nodes <node_name> key:NoSchedule-

---
kubectl get svc <svc-name> -o json | jq '.spec.clusterIP'

--- Sublime Settings (JSON) ---
{
  "color_scheme": "Packages/Theme - Monokai Pro/Monokai Pro.sublime-color-scheme",
  "font_size": 11,
  "ignored_packages":
  [
    "Vintage"
  ],
  "tab_size": 2,
  "theme": "Adaptive.sublime-theme",
  "translate_tabs_to_spaces": true,
  "word_wrap": "true",
  "highlight_line": true,
  "block_caret": true,
  "match_brackets_angle": true,
  "highlight_modified_tabs": true,
  "show_line_endings": true,
  "preview_on_click": false
}
--- bashrs - vagrant/master-1 - alias ---
alias h='history'
alias hc='history -c'
alias k='kubectl'
alias kaf='kubectl apply -f'
alias kow='kubectl -o wide get all'
alias p='python3'
alias pip='pip3'
alias ssh_1='ssh -F /home/vagrant/machines-ssh/config worker-1'
alias ssh_2='ssh -F /home/vagrant/machines-ssh/config worker-2'