
input_dashboard_port=10000
filename="/mnt/d/DOCS/study/k8s-autotest/utils/recommended.yaml"

function fc_test() {
    awk -v port="${input_dashboard_port}" '
BEGIN { inside_spec = 0; inside_ports = 0; type_added = 0; nodeport_added = 0 }
{
    if ($0 ~ /spec:/) {
        inside_spec = 1
        type_added = 0
    }
    if (inside_spec && !type_added && $0 ~ /ports:/) {
        print "  type: NodePort"
        type_added = 1
    }
    if (inside_spec && $0 ~ /ports:/) {
        inside_ports = 1
    }
    if (inside_ports && $0 ~ /- targetPort: 8443/) {
        print
        next
    }
    if (inside_ports && !nodeport_added && $0 ~ /- port: 443/) {
        print
        print "      nodePort: " port
        nodeport_added = 1
        inside_ports = 0  # reset after inserting nodePort
        next
    }
    # If nodePort was added, copy remaining lines and exit processing
    if (nodeport_added) {
        print
        while (getline > 0) {
            print
        }
        exit
    }
    print
}' "$filename" > tmpfile && mv tmpfile "$filename"
}

fc_test

