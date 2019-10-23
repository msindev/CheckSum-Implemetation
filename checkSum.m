% CheckSum Implementation for 8,16 and 32 bit numbers.
optckLength = input("8-bit,16-bit or 32 bit checksum? :");

n = input("Enter total number of hex codes: ");

datawords = strings([1,n]);
binDatawords = strings([1,n]);


fprintf("Enter hex codes: \n");
for i=1:n
    datawords(i) = input("Enter code: ",'s');
    binDatawords(i) = dec2bin(hex2dec(datawords(i)));
end

% optckLength = 0;
% % dWordLength = strlength(datawords(1));
% if(dWordLength == 1 || dWordLength == 2)
%     optckLength = 8;
% elseif(dWordLength ==3 || dWordLength == 4)
%     optckLength = 16;
% elseif(dWordLength>=5 && dWordLength<=8)
%     optckLength = 32;
% end

sentChecksum = checksumFunc(binDatawords,n,optckLength);
fprintf("Sent Checksum = %s\n",sentChecksum);

fprintf("********AT RECEIVER'S END: **********\n");
fprintf("Received Data:\n");
receivedDatawords = [datawords, sentChecksum];
binreceivedDatawords = [binDatawords, dec2bin(hex2dec(sentChecksum))];

for i=1:n+1
    fprintf("%s\n",receivedDatawords(i));
end

receivedChecksum = checksumFunc(binreceivedDatawords, n+1, optckLength)
fprintf("Received Checksum = %s\n", receivedChecksum);

if(hex2dec(receivedChecksum)==0)
    fprintf("Data Successfully Transmitted\n");
else
    fprintf("Data corrupted\n");
end


function checksumHex = checksumFunc(binDatawords,n,optckLength)
    checksum = "0";
    for i=1:n
        checksum = dec2bin(bin2dec(checksum)+bin2dec(binDatawords(i)));
    end

    cksumLength = strlength(checksum);
    if(cksumLength < optckLength)
        checksum = [repmat('0', 1, optckLength-cksumLength), checksum];
    elseif(cksumLength > optckLength)
        tempLength = cksumLength - optckLength;
        temp = extractBetween(checksum, 1,tempLength);
        checksum = extractBetween(checksum, tempLength+1,cksumLength);
        checksum = dec2bin(bin2dec(checksum) + bin2dec(temp));
    end

    for i=1:optckLength
        if(checksum(i)=='1')
            checksum(i)='0';
        else
            checksum(i)='1';
        end
    end

    checksumHex = dec2hex(bin2dec(checksum));
end