<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'instanceid' => 'oc18kis8i0xe',
  'passwordsalt' => '7Q2XP0zkKoCifJOsleV7OhQ5II8R+F',
  'secret' => 'niIUMzeXMeadrnDxXUmQLHXd++d/J5H/jbatjEf8+o7+8fma',
  'trusted_domains' => 
  array (
    0 => 'matcha.ilikebubbletea.me',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'sqlite3',
  'version' => '23.0.0.10',
  
  /**
 * Mail Parameters
 *
 * These configure the email settings for Nextcloud notifications and password
 * resets.
 */

/**
 * The return address that you want to appear on emails sent by the Nextcloud
 * server, for example ``nc-admin@example.com``, substituting your own domain,
 * of course.
 */
'mail_domain' => 'ilikebubbletea.me',

/**
 * FROM address that overrides the built-in ``sharing-noreply`` and
 * ``lostpassword-noreply`` FROM addresses.
 *
 * Defaults to different from addresses depending on the feature.
 */
'mail_from_address' => 'nextcloud',

/**
 * Enable SMTP class debugging.
 *
 * Defaults to ``false``
 */
'mail_smtpdebug' => false,

/**
 * Which mode to use for sending mail: ``sendmail``, ``smtp`` or ``qmail``.
 *
 * If you are using local or remote SMTP, set this to ``smtp``.
 *
 * For the ``sendmail`` option you need an installed and working email system on
 * the server, with ``/usr/sbin/sendmail`` installed on your Unix system.
 *
 * For ``qmail`` the binary is /var/qmail/bin/sendmail, and it must be installed
 * on your Unix system.
 *
 * Defaults to ``smtp``
 */
'mail_smtpmode' => 'smtp',

/**
 * This depends on ``mail_smtpmode``. Specify the IP address of your mail
 * server host. This may contain multiple hosts separated by a semi-colon. If
 * you need to specify the port number append it to the IP address separated by
 * a colon, like this: ``127.0.0.1:24``.
 *
 * Defaults to ``127.0.0.1``
 */
'mail_smtphost' => '127.0.0.1',

/**
 * This depends on ``mail_smtpmode``. Specify the port for sending mail.
 *
 * Defaults to ``25``
 */
'mail_smtpport' => 25,

/**
 * This depends on ``mail_smtpmode``. This sets the SMTP server timeout, in
 * seconds. You may need to increase this if you are running an anti-malware or
 * spam scanner.
 *
 * Defaults to ``10`` seconds
 */
'mail_smtptimeout' => 10,

/**
 * This depends on ``mail_smtpmode``. Specify when you are using ``ssl`` for SSL/TLS or
 * ``tls`` for STARTTLS, or leave empty for no encryption.
 *
 * Defaults to ``''`` (empty string)
 */
'mail_smtpsecure' => '',

/**
 * This depends on ``mail_smtpmode``. Change this to ``true`` if your mail
 * server requires authentication.
 *
 * Defaults to ``false``
 */
'mail_smtpauth' => false,

/**
 * This depends on ``mail_smtpmode``. If SMTP authentication is required, choose
 * the authentication type as ``LOGIN`` or ``PLAIN``.
 *
 * Defaults to ``LOGIN``
 */
'mail_smtpauthtype' => 'LOGIN',

/**
 * This depends on ``mail_smtpauth``. Specify the username for authenticating to
 * the SMTP server.
 *
 * Defaults to ``''`` (empty string)
 */
'mail_smtpname' => '',

/**
 * This depends on ``mail_smtpauth``. Specify the password for authenticating to
 * the SMTP server.
 *
 * Default to ``''`` (empty string)
 */
'mail_smtppassword' => '',

/**
 * Replaces the default mail template layout. This can be utilized if the
 * options to modify the mail texts with the theming app is not enough.
 * The class must extend  ``\OC\Mail\EMailTemplate``
 */
'mail_template_class' => '\OC\Mail\EMailTemplate',

/**
 * Email will be send by default with an HTML and a plain text body. This option
 * allows to only send plain text emails.
 */
'mail_send_plaintext_only' => false,

/**
 * This depends on ``mail_smtpmode``. Array of additional streams options that
 * will be passed to underlying Swift mailer implementation.
 * Defaults to an empty array.
 */
'mail_smtpstreamoptions' => [],

/**
 * Which mode is used for sendmail/qmail: ``smtp`` or ``pipe``.
 *
 * For ``smtp`` the sendmail binary is started with the parameter ``-bs``:
 *   - Use the SMTP protocol on standard input and output.
 *
 * For ``pipe`` the binary is started with the parameters ``-t``:
 *   - Read message from STDIN and extract recipients.
 *
 * Defaults to ``smtp``
 */
'mail_sendmailmode' => 'smtp',
  
  
  'overwrite.cli.url' => 'http://matcha.ilikebubbletea.me',
  'installed' => true,
);
