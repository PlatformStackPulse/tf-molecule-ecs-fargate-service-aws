# Unit Tests for tf-molecule-ecs-fargate-service-aws
#
# These tests use a mock AWS provider — no real AWS calls are made, no
# credentials required. They run `terraform plan` and assert on values that
# are KNOWN at plan time (the tf-label id, which is config-set as the
# cluster/service name) rather than computed ARNs/IDs (which are unknown under a
# mock provider and would error if asserted on).
#
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose

mock_provider "aws" {}

# tf-label identity + the module's own required inputs.
variables {
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Required (no default) inputs of this molecule:
  subnet_ids = ["subnet-0123456789abcdef0"]
  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "public.ecr.aws/nginx/nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ---------------------------------------------------------------------------
# Test: module creates resources when enabled (default)
# ---------------------------------------------------------------------------
# The cluster name is set from the tf-label id (`name = module.this.id`), so it
# is a config-set attribute and is KNOWN at plan even under a mock provider.
run "creates_when_enabled" {
  command = plan

  # The cluster name is `name = module.this.id` in the atom, so it is a
  # config-set attribute that is KNOWN at plan even under a mock provider.
  assert {
    condition     = output.cluster_name == "eg-test-thing"
    error_message = "cluster_name should equal the tf-label id 'eg-test-thing' when enabled"
  }

  # The service name is also `name = module.this.id` — a plan-known value.
  assert {
    condition     = output.service_name == "eg-test-thing"
    error_message = "service_name should equal the tf-label id 'eg-test-thing' when enabled"
  }
}

# ---------------------------------------------------------------------------
# Test: a custom tf-label identity flows through to the cluster name
# ---------------------------------------------------------------------------
# Overriding the id elements changes the composed id, proving the tf-label
# identity is wired through the molecule. Still a plan-known assertion.
run "identity_flows_through" {
  command = plan

  variables {
    namespace = "cp"
    stage     = "prod"
    name      = "api"
  }

  assert {
    condition     = output.cluster_name == "cp-prod-api"
    error_message = "cluster_name should reflect the composed tf-label id 'cp-prod-api'"
  }
}
