admins = { "focus@${XMPP_AUTH_DOMAIN}" }

VirtualHost "${XMPP_DOMAIN}"
        authentication = "anonymous"
        ssl = {
                key = "/config/certs/${XMPP_DOMAIN}.key";
                certificate = "/config/certs/${XMPP_DOMAIN}.crt";
        }
        modules_enabled = {
            "bosh";
            "pubsub";
            "ping";
        }

        c2s_require_encryption = false

VirtualHost "${XMPP_AUTH_DOMAIN}"
    ssl = {
        key = "/config/certs/${XMPP_AUTH_DOMAIN}.key";
        certificate = "/config/certs/${XMPP_AUTH_DOMAIN}.crt";
    }
    authentication = "internal_plain"

Component "conference.${XMPP_DOMAIN}" "muc"
    storage = "null"

Component "jitsi-videobridge.${XMPP_DOMAIN}"
    component_secret = "${JVB_COMPONENT_SECRET}"

Component "focus.${XMPP_DOMAIN}"
    component_secret = "${JICOFO_COMPONENT_SECRET}"

