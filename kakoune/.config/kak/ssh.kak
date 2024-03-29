# SSH configuration language

# Detection
hook global BufCreate .*[.]ssh/config %{
 set-option buffer filetype ssh_config
}

# Initialization
hook global WinSetOption filetype=ssh_config %{
  require-module ssh_config
  hook -once -always window WinSetOption filetype=.* %{ remove-hooks window ssh_config-.+ }
}

hook -group ssh-config-highlight global WinSetOption filetype=ssh_config %{
  add-highlighter window/ssh_config ref ssh_config
  hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/ssh_config }
}

provide-module ssh_config %§

# Highlighters
add-highlighter shared/ssh_config regions
add-highlighter shared/ssh_config/code default-region group

# Comments
add-highlighter shared/ssh_config/comment region '#'  '$' fill comment

# Constants
add-highlighter shared/ssh_config/code/constants regex '\b(yes|no|ask|confirm|any|auto|force|autoask|none)\b' 0:value
add-highlighter shared/ssh_config/code/ciphers regex '\b(3des-cbc|blowfish-cbc|cast128-cbc|arcfour|arcfour128|arcfour256|aes128-cbc|aes192-cbc|aes256-cbc|rijndael-cbc@lysator\.liu.se|aes128-ctr|aes192-ctr|aes256-ctr|aes128-gcm@openssh\.com|aes256-gcm@openssh\.com|chacha20-poly1305@openssh\.com)\b' 0:value
add-highlighter shared/ssh_config/code/algorithms regex '\b(ssh-ed25519|ssh-ed25519-cert-v01@openssh\.com|sk-ssh-ed25519@openssh\.com|sk-ssh-ed25519-cert-v01@openssh\.com|ssh-rsa|rsa-sha2-256|rsa-sha2-512|ssh-dss|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521|sk-ecdsa-sha2-nistp256@openssh\.com|ssh-rsa-cert-v01@openssh\.com|rsa-sha2-256-cert-v01@openssh\.com|rsa-sha2-512-cert-v01@openssh\.com|ssh-dss-cert-v01@openssh\.com|ecdsa-sha2-nistp256-cert-v01@openssh\.com|ecdsa-sha2-nistp384-cert-v01@openssh\.com|ecdsa-sha2-nistp521-cert-v01@openssh\.com|sk-ecdsa-sha2-nistp256-cert-v01@openssh\.com)\b' 0:type
add-highlighter shared/ssh_config/code/config-match regex '\b(canonical|final|exec|host|originalhost|user|localuser|all)\b' 0:type

# Strings
add-highlighter shared/ssh_config/string region '"' '(?<!\\)(?:\\\\)*"' fill string

# Numbers
add-highlighter shared/ssh_config/code/numbers regex '\b\d+\b' 0:value

# Keywords
add-highlighter shared/ssh_config/code/keywords regex '\b(AddressFamily|AddKeysToAgent|BatchMode|BindAddress|BindInterface|CanonicalDomains|CanonicalizeFallbackLocal|CanonicalizeHostname|CanonicalizeMaxDots|CanonicalizePermittedCNAMEs|CASignatureAlgorithms|CertificateFile|ChallengeResponseAuthentication|CheckHostIP|Ciphers|ClearAllForwardings|Compression|ConnectTimeout|ConnectionAttempts|ControlMaster|ControlPath|ControlPersist|DynamicForward|EnableSSHKeysign|EscapeChar|ExitOnForwardFailure|FingerprintHash|ForkAfterAuthentication|ForwardAgent|ForwardX11|ForwardX11Timeout|ForwardX11Trusted|GSSAPIAuthentication|GSSAPIDelegateCredentials|GatewayPorts|GlobalKnownHostsFile|HashKnownHosts|HostKeyAlgorithms|Host|HostKeyAlias|HostName|HostbasedAuthentication|HostbasedAcceptedAlgorithms|HostbasedKeyTypes|IPQoS|IdentitiesOnly|IdentityAgent|IdentityFile|IgnoreUnknown|Include|IPQoS|KbdInteractiveAuthentication|KbdInteractiveDevices|KexAlgorithms|KnownHostsCommand|LocalCommand|LocalForward|LogLevel|LogVerbose|MACs|Match|NoHostAuthenticationForLocalhost|NumberOfPasswordPrompts|PKCS11Provider|PasswordAuthentication|PermitLocalCommand|PermitRemoteOpen|Port|PreferredAuthentications|ProxyCommand|ProxyJump|ProxyUseFDPass|PubkeyAcceptedAlgorithms|PubkeyAcceptedKeyTypes|PubkeyAuthentication|RekeyLimit|RemoteCommand|RemoteForward|RequestTTY|RequiredRSASize|RevokedHostKeys|SecurityKeyProvider|SendEnv|ServerAliveCountMax|ServerAliveInterval|SessionType|SmartcardDevice|SetEnv|StdinNull|StreamLocalBindMask|StreamLocalBindUnlink|StrictHostKeyChecking|SyslogFacility|TCPKeepAlive|Tunnel|TunnelDevice|UseBlacklistedKeys|UpdateHostKeys|User|UserKnownHostsFile|VerifyHostKeyDNS|VisualHostKey|XAuthLocation)\b' 0:keyword

# Deprecated keywords
add-highlighter shared/ssh_config/code/deprecated_keywords regex '\b(Cipher|GSSAPIClientIdentity|GSSAPIKeyExchange|GSSAPIRenewalForcesRekey|GSSAPIServerIdentity|GSSAPITrustDNS|GSSAPITrustDns|Protocol|RSAAuthentication|RhostsRSAAuthentication|CompressionLevel|UseRoaming|UsePrivilegedPort)\b' 0:Error


§
