Attribute VB_Name = "modLanguage"
Option Explicit

' //
' //  Primary language IDs.
' //

Public Const LANG_NEUTRAL                     As Integer = &H0
Public Const LANG_INVARIANT                   As Integer = &H7F

Public Const LANG_AFRIKAANS                   As Integer = &H36
Public Const LANG_ALBANIAN                    As Integer = &H1C
Public Const LANG_ARABIC                      As Integer = &H1
Public Const LANG_ARMENIAN                    As Integer = &H2B
Public Const LANG_ASSAMESE                    As Integer = &H4D
Public Const LANG_AZERI                       As Integer = &H2C
Public Const LANG_BASQUE                      As Integer = &H2D
Public Const LANG_BELARUSIAN                  As Integer = &H23
Public Const LANG_BENGALI                     As Integer = &H45
Public Const LANG_BULGARIAN                   As Integer = &H2
Public Const LANG_CATALAN                     As Integer = &H3
Public Const LANG_CHINESE                     As Integer = &H4
Public Const LANG_CROATIAN                    As Integer = &H1A
Public Const LANG_CZECH                       As Integer = &H5
Public Const LANG_DANISH                      As Integer = &H6
Public Const LANG_DIVEHI                      As Integer = &H65
Public Const LANG_DUTCH                       As Integer = &H13
Public Const LANG_ENGLISH                     As Integer = &H9
Public Const LANG_ESTONIAN                    As Integer = &H25
Public Const LANG_FAEROESE                    As Integer = &H38
Public Const LANG_FARSI                       As Integer = &H29
Public Const LANG_FINNISH                     As Integer = &HB
Public Const LANG_FRENCH                      As Integer = &HC
Public Const LANG_GALICIAN                    As Integer = &H56
Public Const LANG_GEORGIAN                    As Integer = &H37
Public Const LANG_GERMAN                      As Integer = &H7
Public Const LANG_GREEK                       As Integer = &H8
Public Const LANG_GUJARATI                    As Integer = &H47
Public Const LANG_HEBREW                      As Integer = &HD
Public Const LANG_HINDI                       As Integer = &H39
Public Const LANG_HUNGARIAN                   As Integer = &HE
Public Const LANG_ICELANDIC                   As Integer = &HF
Public Const LANG_INDONESIAN                  As Integer = &H21
Public Const LANG_ITALIAN                     As Integer = &H10
Public Const LANG_JAPANESE                    As Integer = &H11
Public Const LANG_KANNADA                     As Integer = &H4B
Public Const LANG_KASHMIRI                    As Integer = &H60
Public Const LANG_KAZAK                       As Integer = &H3F
Public Const LANG_KONKANI                     As Integer = &H57
Public Const LANG_KOREAN                      As Integer = &H12
Public Const LANG_KYRGYZ                      As Integer = &H40
Public Const LANG_LATVIAN                     As Integer = &H26
Public Const LANG_LITHUANIAN                  As Integer = &H27
Public Const LANG_MACEDONIAN                  As Integer = &H2F   '' // the Former Yugoslav Republic of Macedonia
Public Const LANG_MALAY                       As Integer = &H3E
Public Const LANG_MALAYALAM                   As Integer = &H4C
Public Const LANG_MANIPURI                    As Integer = &H58
Public Const LANG_MARATHI                     As Integer = &H4E
Public Const LANG_MONGOLIAN                   As Integer = &H50
Public Const LANG_NEPALI                      As Integer = &H61
Public Const LANG_NORWEGIAN                   As Integer = &H14
Public Const LANG_ORIYA                       As Integer = &H48
Public Const LANG_POLISH                      As Integer = &H15
Public Const LANG_PORTUGUESE                  As Integer = &H16
Public Const LANG_PUNJABI                     As Integer = &H46
Public Const LANG_ROMANIAN                    As Integer = &H18
Public Const LANG_RUSSIAN                     As Integer = &H19
Public Const LANG_SANSKRIT                    As Integer = &H4F
Public Const LANG_SERBIAN                     As Integer = &H1A
Public Const LANG_SINDHI                      As Integer = &H59
Public Const LANG_SLOVAK                      As Integer = &H1B
Public Const LANG_SLOVENIAN                   As Integer = &H24
Public Const LANG_SPANISH                     As Integer = &HA
Public Const LANG_SWAHILI                     As Integer = &H41
Public Const LANG_SWEDISH                     As Integer = &H1D
Public Const LANG_SYRIAC                      As Integer = &H5A
Public Const LANG_TAMIL                       As Integer = &H49
Public Const LANG_TATAR                       As Integer = &H44
Public Const LANG_TELUGU                      As Integer = &H4A
Public Const LANG_THAI                        As Integer = &H1E
Public Const LANG_TURKISH                     As Integer = &H1F
Public Const LANG_UKRAINIAN                   As Integer = &H22
Public Const LANG_URDU                        As Integer = &H20
Public Const LANG_UZBEK                       As Integer = &H43
Public Const LANG_VIETNAMESE                  As Integer = &H2A

' //
' //  Sublanguage IDs.
' //
' //  The name immediately following SUBLANG_ dictates which primary
' //  language ID that sublanguage ID can be combined with to form a
' //  valid language ID.
' //

Public Const SUBLANG_NEUTRAL                  As Integer = &H0     ' // language neutral
Public Const SUBLANG_DEFAULT                  As Integer = &H1     ' // user default
Public Const SUBLANG_SYS_DEFAULT              As Integer = &H2     ' // system default

Public Const SUBLANG_ARABIC_SAUDI_ARABIA      As Integer = &H1     ' // Arabic (Saudi Arabia)
Public Const SUBLANG_ARABIC_IRAQ              As Integer = &H2     ' // Arabic (Iraq)
Public Const SUBLANG_ARABIC_EGYPT             As Integer = &H3     ' // Arabic (Egypt)
Public Const SUBLANG_ARABIC_LIBYA             As Integer = &H4     ' // Arabic (Libya)
Public Const SUBLANG_ARABIC_ALGERIA           As Integer = &H5     ' // Arabic (Algeria)
Public Const SUBLANG_ARABIC_MOROCCO           As Integer = &H6     ' // Arabic (Morocco)
Public Const SUBLANG_ARABIC_TUNISIA           As Integer = &H7     ' // Arabic (Tunisia)
Public Const SUBLANG_ARABIC_OMAN              As Integer = &H8     ' // Arabic (Oman)
Public Const SUBLANG_ARABIC_YEMEN             As Integer = &H9     ' // Arabic (Yemen)
Public Const SUBLANG_ARABIC_SYRIA             As Integer = &HA     ' // Arabic (Syria)
Public Const SUBLANG_ARABIC_JORDAN            As Integer = &HB     ' // Arabic (Jordan)
Public Const SUBLANG_ARABIC_LEBANON           As Integer = &HC     ' // Arabic (Lebanon)
Public Const SUBLANG_ARABIC_KUWAIT            As Integer = &HD     ' // Arabic (Kuwait)
Public Const SUBLANG_ARABIC_UAE               As Integer = &HE     ' // Arabic (U.A.E)
Public Const SUBLANG_ARABIC_BAHRAIN           As Integer = &HF     ' // Arabic (Bahrain)
Public Const SUBLANG_ARABIC_QATAR             As Integer = &H10    ' // Arabic (Qatar)
Public Const SUBLANG_AZERI_LATIN              As Integer = &H1     ' // Azeri (Latin)
Public Const SUBLANG_AZERI_CYRILLIC           As Integer = &H2     ' // Azeri (Cyrillic)
Public Const SUBLANG_CHINESE_TRADITIONAL      As Integer = &H1     ' // Chinese (Taiwan)
Public Const SUBLANG_CHINESE_SIMPLIFIED       As Integer = &H2     ' // Chinese (PR China)
Public Const SUBLANG_CHINESE_HONGKONG         As Integer = &H3     ' // Chinese (Hong Kong S.A.R., P.R.C.)
Public Const SUBLANG_CHINESE_SINGAPORE        As Integer = &H4     ' // Chinese (Singapore)
Public Const SUBLANG_CHINESE_MACAU            As Integer = &H5     ' // Chinese (Macau S.A.R.)
Public Const SUBLANG_DUTCH                    As Integer = &H1     ' // Dutch
Public Const SUBLANG_DUTCH_BELGIAN            As Integer = &H2     ' // Dutch (Belgian)
Public Const SUBLANG_ENGLISH_US               As Integer = &H1     ' // English (USA)
Public Const SUBLANG_ENGLISH_UK               As Integer = &H2     ' // English (UK)
Public Const SUBLANG_ENGLISH_AUS              As Integer = &H3     ' // English (Australian)
Public Const SUBLANG_ENGLISH_CAN              As Integer = &H4     ' // English (Canadian)
Public Const SUBLANG_ENGLISH_NZ               As Integer = &H5     ' // English (New Zealand)
Public Const SUBLANG_ENGLISH_EIRE             As Integer = &H6     ' // English (Irish)
Public Const SUBLANG_ENGLISH_SOUTH_AFRICA     As Integer = &H7     ' // English (South Africa)
Public Const SUBLANG_ENGLISH_JAMAICA          As Integer = &H8     ' // English (Jamaica)
Public Const SUBLANG_ENGLISH_CARIBBEAN        As Integer = &H9     ' // English (Caribbean)
Public Const SUBLANG_ENGLISH_BELIZE           As Integer = &HA     ' // English (Belize)
Public Const SUBLANG_ENGLISH_TRINIDAD         As Integer = &HB     ' // English (Trinidad)
Public Const SUBLANG_ENGLISH_ZIMBABWE         As Integer = &HC     ' // English (Zimbabwe)
Public Const SUBLANG_ENGLISH_PHILIPPINES      As Integer = &HD     ' // English (Philippines)
Public Const SUBLANG_FRENCH                   As Integer = &H1     ' // French
Public Const SUBLANG_FRENCH_BELGIAN           As Integer = &H2     ' // French (Belgian)
Public Const SUBLANG_FRENCH_CANADIAN          As Integer = &H3     ' // French (Canadian)
Public Const SUBLANG_FRENCH_SWISS             As Integer = &H4     ' // French (Swiss)
Public Const SUBLANG_FRENCH_LUXEMBOURG        As Integer = &H5     ' // French (Luxembourg)
Public Const SUBLANG_FRENCH_MONACO            As Integer = &H6     ' // French (Monaco)
Public Const SUBLANG_GERMAN                   As Integer = &H1     ' // German
Public Const SUBLANG_GERMAN_SWISS             As Integer = &H2     ' // German (Swiss)
Public Const SUBLANG_GERMAN_AUSTRIAN          As Integer = &H3     ' // German (Austrian)
Public Const SUBLANG_GERMAN_LUXEMBOURG        As Integer = &H4     ' // German (Luxembourg)
Public Const SUBLANG_GERMAN_LIECHTENSTEIN     As Integer = &H5     ' // German (Liechtenstein)
Public Const SUBLANG_ITALIAN                  As Integer = &H1     ' // Italian
Public Const SUBLANG_ITALIAN_SWISS            As Integer = &H2     ' // Italian (Swiss)
'#if _WIN32_WINNT >= &H0501
'Public Const SUBLANG_KASHMIRI_SASIA           As Integer = &H2     ' // Kashmiri (South Asia)
'#End If
Public Const SUBLANG_KASHMIRI_INDIA           As Integer = &H2     ' // For app compatibility only
Public Const SUBLANG_KOREAN                   As Integer = &H1     ' // Korean (Extended Wansung)
Public Const SUBLANG_LITHUANIAN               As Integer = &H1     ' // Lithuanian
Public Const SUBLANG_MALAY_MALAYSIA           As Integer = &H1     ' // Malay (Malaysia)
Public Const SUBLANG_MALAY_BRUNEI_DARUSSALAM  As Integer = &H2     ' // Malay (Brunei Darussalam)
Public Const SUBLANG_NEPALI_INDIA             As Integer = &H2     ' // Nepali (India)
Public Const SUBLANG_NORWEGIAN_BOKMAL         As Integer = &H1     ' // Norwegian (Bokmal)
Public Const SUBLANG_NORWEGIAN_NYNORSK        As Integer = &H2     ' // Norwegian (Nynorsk)
Public Const SUBLANG_PORTUGUESE               As Integer = &H2     ' // Portuguese
Public Const SUBLANG_PORTUGUESE_BRAZILIAN     As Integer = &H1     ' // Portuguese (Brazilian)
Public Const SUBLANG_SERBIAN_LATIN            As Integer = &H2     ' // Serbian (Latin)
Public Const SUBLANG_SERBIAN_CYRILLIC         As Integer = &H3     ' // Serbian (Cyrillic)
Public Const SUBLANG_SPANISH                  As Integer = &H1     ' // Spanish (Castilian)
Public Const SUBLANG_SPANISH_MEXICAN          As Integer = &H2     ' // Spanish (Mexican)
Public Const SUBLANG_SPANISH_MODERN           As Integer = &H3     ' // Spanish (Spain)
Public Const SUBLANG_SPANISH_GUATEMALA        As Integer = &H4     ' // Spanish (Guatemala)
Public Const SUBLANG_SPANISH_COSTA_RICA       As Integer = &H5     ' // Spanish (Costa Rica)
Public Const SUBLANG_SPANISH_PANAMA           As Integer = &H6     ' // Spanish (Panama)
Public Const SUBLANG_SPANISH_DOMINICAN_REPUBLIC As Integer = &H7   ' // Spanish (Dominican Republic)
Public Const SUBLANG_SPANISH_VENEZUELA        As Integer = &H8     ' // Spanish (Venezuela)
Public Const SUBLANG_SPANISH_COLOMBIA         As Integer = &H9     ' // Spanish (Colombia)
Public Const SUBLANG_SPANISH_PERU             As Integer = &HA     ' // Spanish (Peru)
Public Const SUBLANG_SPANISH_ARGENTINA        As Integer = &HB     ' // Spanish (Argentina)
Public Const SUBLANG_SPANISH_ECUADOR          As Integer = &HC     ' // Spanish (Ecuador)
Public Const SUBLANG_SPANISH_CHILE            As Integer = &HD     ' // Spanish (Chile)
Public Const SUBLANG_SPANISH_URUGUAY          As Integer = &HE     ' // Spanish (Uruguay)
Public Const SUBLANG_SPANISH_PARAGUAY         As Integer = &HF     ' // Spanish (Paraguay)
Public Const SUBLANG_SPANISH_BOLIVIA          As Integer = &H10    ' // Spanish (Bolivia)
Public Const SUBLANG_SPANISH_EL_SALVADOR      As Integer = &H11    ' // Spanish (El Salvador)
Public Const SUBLANG_SPANISH_HONDURAS         As Integer = &H12    ' // Spanish (Honduras)
Public Const SUBLANG_SPANISH_NICARAGUA        As Integer = &H13    ' // Spanish (Nicaragua)
Public Const SUBLANG_SPANISH_PUERTO_RICO      As Integer = &H14    ' // Spanish (Puerto Rico)
Public Const SUBLANG_SWEDISH                  As Integer = &H1     ' // Swedish
Public Const SUBLANG_SWEDISH_FINLAND          As Integer = &H2     ' // Swedish (Finland)
Public Const SUBLANG_URDU_PAKISTAN            As Integer = &H1     ' // Urdu (Pakistan)
Public Const SUBLANG_URDU_INDIA               As Integer = &H2     ' // Urdu (India)
Public Const SUBLANG_UZBEK_LATIN              As Integer = &H1     ' // Uzbek (Latin)
Public Const SUBLANG_UZBEK_CYRILLIC           As Integer = &H2     ' // Uzbek (Cyrillic)

