whistle is a bash script to automate recon by utilizing subdomain discovery tools, httprobe, and  gowitness to screenshot each live sub.
## prequisites:
assetfinder, subfinder, sublister, amass, httprobe, gowitness
# flags:
```
Usage: ./whistle.sh -d <domain> -flags  -o <out_folder>

  -d <domain>    Target domain
  -f             Run fast tools only (assetfinder, subfinder, sublister)
  -a             Run all tools
  -w <wordlist>  Custom wordlist
  -s             Screenshot live domains with gowitness
  -o <filename>  Save output to a file
 
```
## example:
`./whistle.sh -d google.com -a -s -o google_recon`


## demo:
![image](https://github.com/user-attachments/assets/529759f8-bac2-4d95-9bd8-545f422dc172)

![image](https://github.com/user-attachments/assets/153f1217-d920-46db-99b8-1fc232b9be3f)


## to be added:
- threads
