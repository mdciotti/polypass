prime = 5915587277

# Generate number from passphrase
txt_to_num = (str) ->
	charset = " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-"
	max = str.length - 1
	result = 0
	for c, i in str
		index = charset.indexOf c
		if index < 0 then return null
		result += index * Math.pow(10, max - i)
	result

# Split the number into shares
split = (number, available, needed) ->
	coef = []
	shares = []

	coef[0] = number

	for c in [1...available] by 1
		coef[c] = Math.floor(Math.random() * prime)

	for x in [0..available] by 1
		accum = coef[0]

		for exp in [1...needed] by 1
			accum += coef[exp] * Math.pow(x, exp)
		
		shares[x] = [x, accum]

	return shares
	
join = (shares) ->
	accum = 0
	for formula in [0...shares.length] by 1
		numerator = denominator = 1

		for count in [0...shares.length] by 1
			continue if formula is count
			startposition = shares[formula][0]
			value = shares[formula][1]
			nextposition = shares[count][0]
			numerator *= -nextposition
			denominator *= startposition - nextposition

		accum += ((value * numerator * 2) + 1) / (denominator * 2)

	return Math.round(accum % prime)

toB64 = (num) ->
	charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	out = ""

	return "0" if num is 0

	while num > 0
		out = charset.charAt(num % 64) + out
		num = Math.floor(num / 64)

	return out
