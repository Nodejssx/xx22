#!/bin/bash

# API URL'si
api_url="https://mempool.fractalbitcoin.io/api/v1/fees/recommended"

# Komut template
command_template="yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 --fee-rate"

while true; do
    # API'den verileri çek
    fees=$(curl -s "$api_url")
    
    # JSON'dan halfHourFee değerini al
    halfHourFee=$(echo "$fees" | jq '.halfHourFee')

    # halfHourFee 100'den küçük mü kontrol et
    if [ "$halfHourFee" -lt 100 ]; then
        fee_rate=$halfHourFee
        echo "Fee rate $fee_rate olarak belirlendi, komut çalıştırılıyor."

        # Komutu çalıştır
        command="$command_template $fee_rate"
        $command
        result=$?

        if [ $result -ne 0 ]; then
            echo "Komut başarısız oldu, hata kodu: $result"
            exit 1
        fi
    else
        echo "Fee rate $halfHourFee 100'den büyük, komut çalıştırılmayacak."
    fi

    # Kontrolden sonra 3 saniye bekle
    sleep 3
done
