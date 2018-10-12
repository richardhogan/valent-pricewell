package com.valent.pricewell
import org.apache.shiro.SecurityUtils
import com.google.i18n.phonenumbers.NumberParseException
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.Phonenumber.PhoneNumber
import com.google.i18n.phonenumbers.PhoneNumberUtil.PhoneNumberFormat
import org.codehaus.groovy.grails.commons.ConfigurationHolder


class PhoneNumberService {

    static transactional = true
	public static final Map countryIso = [
						"AALAND ISLANDS"                                  :"AX", "AFGHANISTAN"                                     :"AF",
						"ALBANIA"                                         :"AL", "ALGERIA"                                         :"DZ",
						"AMERICAN SAMOA"                                  :"AS", "ANDORRA"                                         :"AD",
						"ANGOLA"                                          :"AO", "ANGUILLA"                                        :"AI",
						"ANTARCTICA"                                      :"AQ", "ANTIGUA AND BARBUDA"                             :"AG",
						"ARGENTINA"                                       :"AR", "ARMENIA"                                         :"AM",
						"ARUBA"                                           :"AW", "AUSTRALIA"                                       :"AU",
						"AUSTRIA"                                         :"AT", "AZERBAIJAN"                                      :"AZ",
						"BAHAMAS"                                         :"BS", "BAHRAIN"                                         :"BH",
						"BANGLADESH"                                      :"BD", "BARBADOS"                                        :"BB",
						"BELARUS"                                         :"BY", "BELGIUM"                                         :"BE",
						"BELIZE"                                          :"BZ", "BENIN"                                           :"BJ",
						"BERMUDA"                                         :"BM", "BHUTAN"                                          :"BT",
						"BOLIVIA"                                         :"BO", "BOSNIA AND HERZEGOWINA"                          :"BA",
						"BOTSWANA"                                        :"BW", "BOUVET ISLAND"                                   :"BV",
						"BRAZIL"                                          :"BR", "BRITISH INDIAN OCEAN TERRITORY"                  :"IO",
						"BRUNEI DARUSSALAM"                               :"BN", "BULGARIA"                                        :"BG",
						"BURKINA FASO"                                    :"BF", "BURUNDI"                                         :"BI",
						"CAMBODIA"                                        :"KH", "CAMEROON"                                        :"CM",
						"CANADA"                                          :"CA", "CAPE VERDE"                                      :"CV",
						"CAYMAN ISLANDS"                                  :"KY", "CENTRAL AFRICAN REPUBLIC"                        :"CF",
						"CHAD"                                            :"TD", "CHILE"                                           :"CL",
						"CHINA"                                           :"CN", "CHRISTMAS ISLAND"                                :"CX",
						"COCOS ISLANDS"                                   :"CC", "COLOMBIA"                                        :"CO",
						"COMOROS"                                         :"KM", "CONGO"                                           :"CG",
						"COOK ISLANDS"                                    :"CK", "COSTA RICA"                                      :"CR",
						"COTE D'IVOIRE"                                   :"CI", "CROATIA"                                         :"HR",
						"CUBA"                                            :"CU", "CYPRUS"                                          :"CY",
						"CZECH REPUBLIC"                                  :"CZ", "DENMARK"                                         :"DK",
						"DJIBOUTI"                                        :"DJ", "DOMINICA"                                        :"DM",
						"DOMINICAN REPUBLIC"                              :"DO", "ECUADOR"                                         :"EC",
						"EGYPT"                                           :"EG", "EL SALVADOR"                                     :"SV",
						"EQUATORIAL GUINEA"                               :"GQ", "ERITREA"                                         :"ER",
						"ESTONIA"                                         :"EE", "ETHIOPIA"                                        :"ET",
						"FALKLAND ISLAND"                                 :"FK", "FAROE ISLANDS"                                   :"FO",
						"FIJI"                                            :"FJ", "FINLAND"                                         :"FI",
						"FRANCE"                                          :"FR", "FRENCH GUIANA"                                   :"GF",
						"FRENCH POLYNESIA"                                :"PF", "FRENCH SOUTHERN TERRITORIES"                     :"TF",
						"GABON"                                           :"GA", "GAMBIA"                                          :"GM",
						"GEORGIA"                                         :"GE", "GERMANY"                                         :"DE",
						"GHANA"                                           :"GH", "GIBRALTAR"                                       :"GI",
						"GREECE"                                          :"GR", "GREENLAND"                                       :"GL",
						"GRENADA"                                         :"GD", "GUADELOUPE"                                      :"GP",
						"GUAM"                                            :"GU", "GUATEMALA"                                       :"GT",
						"GUINEA"                                          :"GN", "GUINEA-BISSAU"                                   :"GW",
						"GUYANA"                                          :"GY", "HAITI"                                           :"HT",
						"HEARD AND MC DONALD ISLANDS"                     :"HM", "HONDURAS"                                        :"HN",
						"HONG KONG"                                       :"HK", "HUNGARY"                                         :"HU",
						"ICELAND"                                         :"IS", "INDIA"                                           :"IN",
						"INDONESIA"                                       :"ID", "IRAN"                                            :"IR",
						"IRAQ"                                            :"IQ", "IRELAND"                                         :"IE",
						"ISRAEL"                                          :"IL", "ITALY"                                           :"IT",
						"JAMAICA"                                         :"JM", "JAPAN"                                           :"JP",
						"JORDAN"                                          :"JO", "KAZAKHSTAN"                                      :"KZ",
						"KENYA"                                           :"KE", "KIRIBATI"                                        :"KI",
						"KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF"          :"KP", "KOREA, REPUBLIC OF"                              :"KR",
						"KUWAIT"                                          :"KW", "KYRGYZSTAN"                                      :"KG",
						"LAO"                                             :"LA", "LATVIA"                                          :"LV",
						"LEBANON"                                         :"LB", "LESOTHO"                                         :"LS",
						"LIBERIA"                                         :"LR", "LIBYAN ARAB JAMAHIRIYA"                          :"LY",
						"LIECHTENSTEIN"                                   :"LI", "LITHUANIA"                                       :"LT",
						"LUXEMBOURG"                                      :"LU", "MACAU"                                           :"MO",
						"MACEDONIA"                                       :"MK", "MADAGASCAR"                                      :"MG",
						"MALAWI"                                          :"MW", "MALAYSIA"                                        :"MY",
						"MALDIVES"                                        :"MV", "MALI"                                            :"ML",
						"MALTA"                                           :"MT", "MARSHALL ISLANDS"                                :"MH",
						"MARTINIQUE"                                      :"MQ", "MAURITANIA"                                      :"MR",
						"MAURITIUS"                                       :"MU", "MAYOTTE"                                         :"YT",
						"MEXICO"                                          :"MX", "MICRONESIA"                                      :"FM",
						"MOLDOVA"                                         :"MD", "MONACO"                                          :"MC",
						"MONGOLIA"                                        :"MN", "MONTSERRAT"                                      :"MS",
						"MOROCCO"                                         :"MA", "MOZAMBIQUE"                                      :"MZ",
						"MYANMAR"                                         :"MM", "NAMIBIA"                                         :"NA",
						"NAURU"                                           :"NR", "NEPAL"                                           :"NP",
						"NETHERLANDS"                                     :"NL", "NETHERLANDS ANTILLES"                            :"AN",
						"NEW CALEDONIA"                                   :"NC", "NEW ZEALAND"                                     :"NZ",
						"NICARAGUA"                                       :"NI", "NIGER"                                           :"NE",
						"NIGERIA"                                         :"NG", "NIUE"                                            :"NU",
						"NORFOLK ISLAND"                                  :"NF", "NORTHERN MARIANA ISLANDS"                        :"MP",
						"NORWAY"                                          :"NO", "PAKISTAN"                                        :"PK",
						"PALAU"                                           :"PW", "PALESTINIAN"                                     :"PS",
						"PANAMA"                                          :"PA", "PAPUA NEW GUINEA"                                :"PG",
						"PARAGUAY"                                        :"PY", "PERU"                                            :"PE",
						"PHILIPPINES"                                     :"PH", "PITCAIRN"                                        :"PN",
						"POLAND"                                          :"PL", "PORTUGAL"                                        :"PT",
						"PUERTO RICO"                                     :"PR", "QATAR"                                           :"QA",
						"REUNION"                                         :"RE", "ROMANIA"                                         :"RO",
						"RUSSIAN FEDERATION"                              :"RU", "RWANDA"                                          :"RW",
						"SAINT HELENA"                                    :"SH", "SAINT KITTS AND NEVIS"                           :"KN",
						"SAINT LUCIA"                                     :"LC", "SAINT PIERRE AND MIQUELON"                       :"PM",
						"SAINT VINCENT AND THE GRENADINES"                :"VC", "SAMOA"                                           :"WS",
						"SAN MARINO"                                      :"SM", "SAO TOME AND PRINCIPE"                           :"ST",
						"SAUDI ARABIA"                                    :"SA", "SENEGAL"                                         :"SN",
						"SERBIA AND MONTENEGRO"                           :"CS", "SEYCHELLES"                                      :"SC",
						"SIERRA LEONE"                                    :"SL", "SINGAPORE"                                       :"SG",
						"SLOVAKIA"                                        :"SK", "SLOVENIA"                                        :"SI",
						"SOLOMON ISLANDS"                                 :"SB", "SOMALIA"                                         :"SO",
						"SOUTH AFRICA"                                    :"ZA", "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS"    :"GS",
						"SPAIN"                                           :"ES", "SRI LANKA"                                       :"LK",
						"SUDAN"                                           :"SD", "SURINAME"                                        :"SR",
						"SVALBARD AND JAN MAYEN ISLANDS"                  :"SJ", "SWAZILAND"                                       :"SZ",
						"SWEDEN"                                          :"SE", "SWITZERLAND"                                     :"CH",
						"SYRIAN ARAB REPUBLIC"                            :"SY", "TAIWAN"                                          :"TW",
						"TAJIKISTAN"                                      :"TJ", "TANZANIA"                                        :"TZ",
						"THAILAND"                                        :"TH", "TIMOR-LESTE"                                     :"TL",
						"TOGO"                                            :"TG", "TOKELAU"                                         :"TK",
						"TONGA"                                           :"TO", "TRINIDAD AND TOBAGO"                             :"TT",
						"TUNISIA"                                         :"TN", "TURKEY"                                          :"TR",
						"TURKMENISTAN"                                    :"TM", "TURKS AND CAICOS ISLANDS"                        :"TC",
						"TUVALU"                                          :"TV", "UGANDA"                                          :"UG",
						"UKRAINE"                                         :"UA", "UNITED ARAB EMIRATES"                            :"AE",
						"UNITED KINGDOM"                                  :"GB", "UNITED STATES"                                   :"US",
						"UNITED STATES MINOR OUTLYING ISLANDS"            :"UM", "URUGUAY"                                         :"UY",
						"UZBEKISTAN"                                      :"UZ", "VANUATU"                                         :"VU",
						"VATICAN CITY STATE (HOLY SEE)"                   :"VA", "VENEZUELA"                                       :"VE",
						"VIET NAM"                                        :"VN", "VIRGIN ISLANDS (BRITISH)"                        :"VG",
						"VIRGIN ISLANDS (U.S.)"                           :"VI", "WALLIS AND FUTUNA ISLANDS"                       :"WF",
						"WESTERN SAHARA"                                  :"EH", "YEMEN"                                           :"YE",
						"ZAMBIA"                                          :"ZM", "ZIMBABWE"                                        :"ZW"]
	
	public static final Map iso = ["ALA"	:"AX", "AFG"	:"AF", "ALB"	:"AL", "DZA"	:"DZ",
									"ASM"	:"AS", "AND"	:"AD", "AGO"	:"AO", "AIA"	:"AI",
									"ATA"	:"AQ", "ATG"	:"AG", "ARG"	:"AR", "ARM"	:"AM",
									"ABW"	:"AW", "AUS"	:"AU", "AUT"	:"AT", "AZE"	:"AZ",
									"BHS"	:"BS", "BHR"	:"BH", "BGD"	:"BD", "BRB" 	:"BB",
									"BLR"	:"BY", "BEL"	:"BE", "BLZ"	:"BZ", "BEN"	:"BJ",
									"BMU"	:"BM", "BTN"	:"BT", "BOL"	:"BO", "BIH"	:"BA",
									"BWA"	:"BW", "BVT"	:"BV", "BRA"	:"BR", "IOT"	:"IO",
									"BRN"	:"BN", "BGR"	:"BG", "BFA"	:"BF", "BDI"	:"BI",
									"KHM"	:"KH", "CMR"	:"CM", "CAN"	:"CA", "CPV"	:"CV",
									"CYM"	:"KY", "CAF"	:"CF", "TCD"	:"TD", "CHL"	:"CL",
									"CHN"	:"CN", "CXR"	:"CX", "CCK"	:"CC", "COL"	:"CO",
									"COM"	:"KM", "COG"	:"CG", "COK"	:"CK", "CRI"	:"CR",
									"CIV"	:"CI", "HRV"	:"HR", "CUB"	:"CU", "CYP"	:"CY",
									"CZE"	:"CZ", "DNK"	:"DK", "DJI"	:"DJ", "DMA"	:"DM",
									"DOM"	:"DO", "ECU"	:"EC", "EGY"	:"EG", "SLV"	:"SV",
									"GNQ"	:"GQ", "ERI"	:"ER", "EST"	:"EE", "ETH"	:"ET",
									"FLK"	:"FK", "FRO"	:"FO", "FJI"	:"FJ", "FIN"	:"FI",
									"FRA"	:"FR", "FRA"	:"GF", "PYF"	:"PF", "ATF"	:"TF",
									"GAB"	:"GA", "GMB"	:"GM", "GEO"	:"GE", "DEU"	:"DE",
									"GHA"	:"GH", "GIB"	:"GI", "GRC"	:"GR", "GRL"	:"GL",
									"GRD"	:"GD", "GLP"	:"GP", "GUM"	:"GU", "GTM"	:"GT",
									"GIN"	:"GN", "GNB"	:"GW", "GUY"	:"GY", "HTI"	:"HT",
									"HMD"	:"HM", "HND"	:"HN", "HKG"	:"HK", "HUN"	:"HU",
									"ISL"	:"IS", "IND"	:"IN", "IDN"	:"ID", "IRN"	:"IR",
									"IRQ"	:"IQ", "IRL"	:"IE", "ISR"	:"IL", "ITA"	:"IT",
									"JAM"	:"JM", "JPN"	:"JP", "JOR"	:"JO", "KAZ"	:"KZ",
									"KEN"	:"KE", "KIR"	:"KI", "PRK"	:"KP", "KOR"	:"KR",
									"KWT"	:"KW", "KGZ"	:"KG", "LAO"	:"LA", "LVA"	:"LV",
									"LBN"	:"LB", "LSO"	:"LS", "LBR"	:"LR", "LBY"	:"LY",
									"LIE"	:"LI", "LTU"	:"LT", "LUX"	:"LU", "MAC"	:"MO",
									"MKD"	:"MK", "MDG"	:"MG", "MWI"	:"MW", "MYS"	:"MY",
									"MDV"	:"MV", "MLI"	:"ML", "MLT"	:"MT", "MHL"	:"MH",
									"MTQ"	:"MQ", "MRT"	:"MR", "MUS"	:"MU", "MYT"	:"YT",
									"MEX"	:"MX", "FSM"	:"FM", "MDA"	:"MD", "MCO"	:"MC",
									"MNG"	:"MN", "MSR"	:"MS", "MAR"	:"MA", "MOZ"	:"MZ",
									"MMR"	:"MM", "NAM"	:"NA", "OMN"	:"OM",
									"NRU"	:"NR", "NPL"	:"NP", "NLD"	:"NL", "ANT"	:"AN",
									"NCL"	:"NC", "NZL"	:"NZ", "NIC"	:"NI", "NER"	:"NE",
									"NGA"	:"NG", "NIU"	:"NU", "NFK"	:"NF", "MNP"	:"MP",
									"NOR"	:"NO", "PAK"	:"PK", "PLW"	:"PW", "PSE"	:"PS",
									"PAN"	:"PA", "PNG"	:"PG", "PRY"	:"PY", "PER"	:"PE",
									"PHL"	:"PH", "PCN"	:"PN", "POL"	:"PL", "PRT"	:"PT",
									"PRI"	:"PR", "QAT"	:"QA", "REU"	:"RE", "ROU"	:"RO",
									"RUS"	:"RU", "RWA"	:"RW", "SHN"	:"SH", "KNA"	:"KN",
									"LCA"	:"LC", "SPM"	:"PM", "VCT"	:"VC", "WSM"	:"WS",
									"SMR"	:"SM", "STP"	:"ST", "SAU"	:"SA", "SEN"	:"SN",
									"SCG"	:"CS", "SYC"	:"SC", "SLE"	:"SL", "SGP"	:"SG",
									"SVK"	:"SK", "SVN"	:"SI", "SLB"	:"SB", "SOM"	:"SO",
									"ZAF"	:"ZA", "SGS"    :"GS", "ESP"	:"ES", "LKA"	:"LK",
									"SDN"	:"SD", "SUR"	:"SR", "SJM"	:"SJ", "SWZ"	:"SZ",
									"SWE"	:"SE", "CHE"	:"CH", "SYR"	:"SY", "TWN"	:"TW",
									"TJK"	:"TJ", "TZA"	:"TZ", "THA"	:"TH", "TLS"	:"TL",
									"TGO"	:"TG", "TKL"	:"TK", "TON"	:"TO", "TTO"	:"TT",
									"TUN"	:"TN", "TUR"	:"TR", "TKM"	:"TM", "TCA"	:"TC",
									"TUV"	:"TV", "UGA"	:"UG", "UKR"	:"UA", "ARE"	:"AE",
									"GBR"	:"GB", "USA"	:"US", "UMI"	:"UM", "URY"	:"UY",
									"UZB"	:"UZ", "VUT"	:"VU", "VAT"	:"VA", "VEN"	:"VE",
									"VNM"	:"VN", "VGB"	:"VG", "VIR"	:"VI", "WLF"	:"WF",
									"WSH"	:"EH", "YEM"	:"YE", "ZMB"	:"ZM", "ZWE"	:"ZW"]
	
    def serviceMethod() {

    }
	
	public String getValidatedPhonenumber(String number, String country)
	{
		//PhoneNumberFormat numberFormat
		String result
	/*	
		if(format == "INTERNATIONAL")
		{
			numberFormat = PhoneNumberFormat.INTERNATIONAL
		}
		else if(format == "NATIONAL")
		{
			numberFormat = PhoneNumberFormat.NATIONAL
		}
		else if(format == "E164")
		{
			numberFormat = PhoneNumberFormat.E164
		}
		else if(format == "RFC3966")
		{
			numberFormat = PhoneNumberFormat.RFC3966
		}
		*/
		PhoneNumberUtil phoneUtil = PhoneNumberUtil.getInstance();
		PhoneNumber numberProto;
		def countryIso = ""
		countryIso = getCountryIso(country)
		try {
		  numberProto = phoneUtil.parse(number, countryIso);
		  
		} catch (NumberParseException e) {
		  System.err.println("NumberParseException was thrown: " + e.toString());
		}
		boolean isValid = phoneUtil.isValidNumber(numberProto)
		println isValid
		if(isValid == true)
		{
			result = phoneUtil.format(numberProto, PhoneNumberFormat.INTERNATIONAL)
		}
		else
		{
			result = "Invalid"
		}
		println result
		return result
	}
	
	public String getCountryIso(String country)
	{
		return iso.get(country.toUpperCase()) 
	}
	
	public def databaseFix(Object ob, String type)
	{
		if(ob?.billingAddress?.billCountry != null && ob?.billingAddress?.billCountry != "" )
		{
			println ob?.billingAddress?.billCountry
			if(ob?.phone != "" && ob.phone != null)
			{
				println ob.phone
				def phone = getValidatedPhonenumber(ob.phone, ob.billingAddress.billCountry)
				if(phone != "Invalid")
				{
					ob.phone = phone
				}
				
				if(type != "Account")
				{
					if(ob.mobile != "" && ob.mobile != null)
					{
						def mobile = getValidatedPhonenumber(ob.mobile, ob?.billingAddress?.billCountry)
						if(mobile != "Invalid")
						{
							ob.mobile = mobile
						}
					}
				}
				
				ob.dateModified = new Date()
				ob.save()
			}
		}
	}
}
