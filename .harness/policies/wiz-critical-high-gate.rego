package pipeline_environment

deny[msg] {
  input.WIZ_REPO_NEW_CRITICAL != "0"
  msg := sprintf("Wiz repo scan found new critical vulnerabilities: %s", [input.WIZ_REPO_NEW_CRITICAL])
}

deny[msg] {
  input.WIZ_REPO_NEW_HIGH != "0"
  msg := sprintf("Wiz repo scan found new high vulnerabilities: %s", [input.WIZ_REPO_NEW_HIGH])
}

deny[msg] {
  input.WIZ_IAC_NEW_CRITICAL != "0"
  msg := sprintf("Wiz IaC scan found new critical vulnerabilities: %s", [input.WIZ_IAC_NEW_CRITICAL])
}

deny[msg] {
  input.WIZ_IAC_NEW_HIGH != "0"
  msg := sprintf("Wiz IaC scan found new high vulnerabilities: %s", [input.WIZ_IAC_NEW_HIGH])
}

deny[msg] {
  input.WIZ_IMAGE_NEW_CRITICAL != "0"
  msg := sprintf("Wiz container scan found new critical vulnerabilities: %s", [input.WIZ_IMAGE_NEW_CRITICAL])
}

deny[msg] {
  input.WIZ_IMAGE_NEW_HIGH != "0"
  msg := sprintf("Wiz container scan found new high vulnerabilities: %s", [input.WIZ_IMAGE_NEW_HIGH])
}
