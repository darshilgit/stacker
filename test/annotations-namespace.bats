load helpers

function setup() {
    stacker_setup
}

function teardown() {
    cleanup
}

@test "namespace arg works" {
    cat > stacker.yaml <<EOF
thing:
    from:
        type: oci
        url: $CENTOS_OCI
    run: ls
EOF
    stacker build --annotations-namespace=namespace.example
    [ "$status" -eq 0 ]
    manifest=$(cat oci/index.json | jq -r .manifests[0].digest | cut -f2 -d:)
    namespace=$(cat oci/blobs/sha256/$manifest | jq -r .annotations | cut -f1 -d:)
    [[ "$namespace" == *"namespace.example"* ]]
}

@test "default namespace arg works" {
    cat > stacker.yaml <<EOF
thing:
    from:
        type: oci
        url: $CENTOS_OCI
    run: ls
EOF
    stacker build
    [ "$status" -eq 0 ]
    manifest=$(cat oci/index.json | jq -r .manifests[0].digest | cut -f2 -d:)
    namespace=$(cat oci/blobs/sha256/$manifest | jq -r .annotations | cut -f1 -d:)
    [[ "$namespace" == *"io.stackeroci"* ]]
}
