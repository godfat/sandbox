<?php
  $cipher = mcrypt_module_open(MCRYPT_BLOWFISH, '', MCRYPT_MODE_CBC, '');
  $encrypted = base64_decode("l+aZOX1DeB1mSaphNaVgin2qKSZ/McfMjl4e9uFUJy8=");

	if (mcrypt_generic_init($cipher, "A key up to 56 bytes long", "01234567") != -1)
	{
		// PHP pads with NULL bytes if $cleartext is not a multiple of the block size..
		$cipherText = mdecrypt_generic($cipher, $encrypted);
		mcrypt_generic_deinit($cipher);

		// Display the result in hex.
		printf("%s\n", substr($cipherText, 8, strlen($cipherText)-8));
	}

	if (mcrypt_generic_init($cipher, "A key up to 56 bytes long", '01234567') != -1)
	{
		// PHP pads with NULL bytes if $cleartext is not a multiple of the block size..
		$cipherText = mcrypt_generic($cipher, '01234567hello from php!!');
		mcrypt_generic_deinit($cipher);

		// Display the result in hex.
		printf("%s\n", base64_encode($cipherText));
	}

?>
