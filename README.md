whistle is a bash script to automate recon by utilizing subdomain discovery tools, httprobe, and  gowitness to screenshot each live sub.
# flags:
Usage: ./whistle.sh -d <domain> -flags  -o <out_folder>

  -d <domain>    Target domain
  -f             Run fast tools only (assetfinder, subfinder, sublister)
  -a             Run all tools
  -w <wordlist>  Custom wordlist
  -s             Screenshot live domains with gowitness
  -o <filename>  Save output to a file
  ## Example:
```
./whistle.sh -d google.com -a -s -o google_recon
```

## demo:
![image](https://github.com/user-attachments/assets/19fb536e-8e53-4f26-a73d-8571094ca705)

![image](https://github.com/user-attachments/assets/153f1217-d920-46db-99b8-1fc232b9be3f)


## to be added:
- threads
