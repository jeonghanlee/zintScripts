zintScripts
===


* Set the CDB url
```
echo "CDB_URL=https://localhost/aaa/bbb" > cdrurl.local
```

* Prepare an input file
```
123456780
123456781
123456782

```

* Generate qr codes with "CDB_URL/views/itemDomainInventory/view?qrId=" and each line of an iput file.

```
 ./batch_qrcodes.bash -l input.txt
 ```
