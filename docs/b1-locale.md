# Locale/TZ

本地化: `docker run -it --rm --shm-size 1g -e VNC_OFFSET=20 -e L=zh_CN --net=host infrastlabs/docker-headless:full`, 推荐[docker-compose.yml](../docker-compose.yml)

环境变量：  
- L=zh_CN 设置语言
- TZ=Asia/Shanghai 设置时区

```bash
# 支持语言列表：
ls /usr/share/locale1/
ar  cs	de  en  en_CA  es	es_AR  fr  fr_CA  it  ja  ko  nl  pt  pt_BR  ru  tr  vi  zh_CN	zh_HK  zh_TW

# L=zh_CN; L=zh_HK; L=zh_TW; 中文
L=pt_PT
L=es_ES 西班牙语(西班牙)
L=fr_FR
L=de_DE
L=ru_RU
L=it_IT
L=ko_KR
L=ja_JP
L=nl_NL 荷兰语(荷兰)
L=cs_CZ 捷克语(捷克共和国)
# https://blog.csdn.net/shenenhua/article/details/79150053
L=tr_TR 土耳其语 -土耳其 
L=ar_EG 阿拉伯语 -埃及 
# L=vi_VI 越南 -越南

```

- zh_CN ![zh_CN](res/loc/zh_CN.png)
- zh_HK ![zh_HK](res/loc/zh_HK.png)
- zh_TW ![zh_TW](res/loc/zh_TW.png)
- 
- 1pt_PT ![1pt_PT](res/loc/1pt_PT.png)
- 2es_ES ![2es_ES](res/loc/2es_ES.png)
- 3fr_FR ![3fr_FR](res/loc/3fr_FR.png)
- 4de_DE ![4de_DE](res/loc/4de_DE.png)
- 5ru_RU ![5ru_RU](res/loc/5ru_RU.png)
- 6it_IT ![6it_IT](res/loc/6it_IT.png)
- 7ko_KR ![7ko_KR](res/loc/7ko_KR.png)
- 8ja_JP ![8ja_JP](res/loc/8ja_JP.png)
- 9nl_NL ![9nl_NL](res/loc/9nl_NL.png)
- 10cs_CZ ![10cs_CZ](res/loc/10cs_CZ.png)
- 11tr_TR ![11tr_TR](res/loc/11tr_TR.png)
- 12ar_SA ![12ar_SA](res/loc/12ar_SA.png)

## 附

```bash
# 语言代码列表
国家/地区	语言代码	
韩文(韩国)	ko_KR       ==
日语(日本)	ja_JP       ==
荷兰语(荷兰)	nl_NL   ==
荷兰语(比利时)	nl_BE
葡萄牙语(葡萄牙)	pt_PT   ==
葡萄牙语(巴西)	    pt_BT
法语(法国)	    fr_FR      ==
法语(卢森堡)	fr_LU
法语(瑞士)	    fr_CH
法语(比利时)	fr_BE
法语(加拿大)	fr_CA	
西班牙语(拉丁美洲)	es_LA
西班牙语(西班牙)	es_ES	==
西班牙语(阿根廷)	es_AR
西班牙语(美国)	    es_US
西班牙语(墨西哥)	es_MX
西班牙语(哥伦比亚)	es_CO	
西班牙语(波多黎各)	es_PR

德语(德国)	    de_DE  ==
德语(奥地利)	de_AT
德语(瑞士)	    de_CH	
俄语(俄罗斯)	ru_RU
意大利语(意大利)	it_IT	==
希腊语(希腊)	    el_GR
挪威语(挪威)	    no_NO	--
匈牙利语(匈牙利)	hu_HU
土耳其语(土耳其)	tr_TR	
捷克语(捷克共和国)	cs_CZ   ==
斯洛文尼亚语	sl_SL
波兰语(波兰)	pl_PL
瑞典语(瑞典)	sv_SE	
西班牙语(智利)

简体中文(中国)      zh_CN
繁体中文(台湾地区)	zh_TW
繁体中文(香港)	    zh_HK
英语(香港)	en_HK
英语(美国)	en_US	
英语(英国)	en_GB
英语(全球)	en_WW	
英语(加拿大)	en_CA
英语(澳大利亚)	en_AU	
英语(爱尔兰)	en_IE
英语(芬兰)   	en_FI
芬兰语(芬兰)	fi_FI
英语(丹麦)	    en_DK	
丹麦语(丹麦)	da_DK
英语(以色列)	en_IL	
希伯来语(以色列) he_IL
英语(南非)	en_ZA
英语(印度)	en_IN
英语(挪威)	en_NO	
英语(新加坡)	en_SG
英语(新西兰)	en_NZ	
英语(印度尼西亚) en_ID
英语(菲律宾)	en_PH
英语(泰国)	    en_TH
英语(马来西亚)	en_MY
英语(阿拉伯)	en_XA
```
