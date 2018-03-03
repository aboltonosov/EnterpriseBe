﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает адрес исходящего запроса для выгрузки документа в УТМ.
//
Функция АдресЗапроса(ВидДокумента, ФорматОбмена, ТекстОшибки) Экспорт
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПодтвержденияТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктРасхожденийТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктОтказаОтТТН Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/WayBillAct_v2", "/opt/in/WayBillAct");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1 Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/ActChargeOn_v2", "/opt/in/ActChargeOn");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2 Тогда
		Возврат "/opt/in/ActChargeOnShop_v2";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра1 Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/ActWriteOff_v2", "/opt/in/ActWriteOff");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра2 Тогда
		Возврат "/opt/in/ActWriteOffShop_v2";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ВозвратИзРегистра2 Тогда
		Возврат "/opt/in/TransferFromShop";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/QueryAP_v2", "/opt/in/QueryAP");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОрганизаций Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/QueryClients_v2", "/opt/in/QueryPartner");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1 Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/QueryRests_v2", "/opt/in/QueryRests");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре2 Тогда
		Возврат "/opt/in/QueryRestsShop_v2";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросСправки1 Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/QueryFormF1", "/opt/in/QueryFormA");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросСправки2 Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/QueryFormF2", "/opt/in/QueryFormB");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросТТН Тогда
		Возврат "/opt/in/QueryResendDoc";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТТН Тогда
		Возврат "/opt/in/RequestRepealWB";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаПостановкиНаБаланс Тогда
		Возврат "/opt/in/RequestRepealACO";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаСписания Тогда
		Возврат "/opt/in/RequestRepealAWO";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ИнформацияОФорматеОбмена Тогда
		Возврат "/opt/in/InfoVersionTTN";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ПередачаВРегистр2 Тогда
		Возврат "/opt/in/TransferToShop";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ПодтверждениеАктаРасхожденийТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ОтказОтАктаРасхожденийТТН Тогда
		Возврат "/opt/in/WayBillTicket";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ПодтверждениеЗапросаНаОтменуПроведенияТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ОтказОтЗапросаНаОтменуПроведенияТТН Тогда
		Возврат "/opt/in/ConfirmRepealWB";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ТТН Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "/opt/in/WayBill_v2", "/opt/in/WayBill");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЧекККМ Тогда
		Возврат "/xml";
		
	Иначе
		ТекстОшибки = НСтр("ru='В функцию %1 передан некорректный параметр %2'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, "ВидыДокументовЕГАИС.АдресЗапроса", ВидДокумента);
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает пространство имен для документа ЕГАИС.
//
Функция ПространствоИмен(ВидДокумента, ФорматОбмена, ТекстОшибки) Экспорт
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктОтказаОтТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПодтвержденияТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктРасхожденийТТН Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "http://fsrar.ru/WEGAIS/ActTTNSingle_v2", "http://fsrar.ru/WEGAIS/ActTTNSingle");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1 Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "http://fsrar.ru/WEGAIS/ActChargeOn_v2", "http://fsrar.ru/WEGAIS/ActChargeOn");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2 Тогда
		Возврат "http://fsrar.ru/WEGAIS/ActChargeOnShop_v2";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра1 Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "http://fsrar.ru/WEGAIS/ActWriteOff_v2", "http://fsrar.ru/WEGAIS/ActWriteOff");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра2 Тогда
		Возврат "http://fsrar.ru/WEGAIS/ActWriteOffShop_v2";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ВозвратИзРегистра2 Тогда
		Возврат "http://fsrar.ru/WEGAIS/TransferFromShop";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОрганизаций
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре2
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросТТН Тогда
		Возврат "http://fsrar.ru/WEGAIS/QueryParameters";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросСправки1
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросСправки2 Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "http://fsrar.ru/WEGAIS/QueryFormF1F2", "http://fsrar.ru/WEGAIS/QueryFormAB");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТТН Тогда
		Возврат "http://fsrar.ru/WEGAIS/RequestRepealWB";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаПостановкиНаБаланс Тогда
		Возврат "http://fsrar.ru/WEGAIS/RequestRepealACO";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаСписания Тогда
		Возврат "http://fsrar.ru/WEGAIS/RequestRepealAWO";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ИнформацияОФорматеОбмена Тогда
		Возврат "http://fsrar.ru/WEGAIS/InfoVersionTTN";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ПередачаВРегистр2 Тогда
		Возврат "http://fsrar.ru/WEGAIS/TransferToShop";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ОтказОтАктаРасхожденийТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ПодтверждениеАктаРасхожденийТТН Тогда
		Возврат "http://fsrar.ru/WEGAIS/ConfirmTicket";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ПодтверждениеЗапросаНаОтменуПроведенияТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ОтказОтЗапросаНаОтменуПроведенияТТН Тогда
		Возврат "http://fsrar.ru/WEGAIS/ConfirmRepealWB";
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ТТН Тогда
		Возврат ?(ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V2, "http://fsrar.ru/WEGAIS/TTNSingle_v2", "http://fsrar.ru/WEGAIS/TTNSingle");
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЧекККМ Тогда
		Возврат "egaischeque.joint.2";
		
	Иначе
		ТекстОшибки = НСтр("ru='В функцию %1 передан некорректный параметр %2'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, "ВидыДокументовЕГАИС.ПространствоИмен", ВидДокумента);
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает префикс переданного пространства имен.
//
Функция ПрефиксПространстваИмен(ПространствоИмен) Экспорт
	
	Если ВРег(ПространствоИмен) = ВРег("http://www.w3.org/2001/XMLSchema-instance") Тогда
		Возврат "xsi";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://www.w3.org/2001/XMLSchema") Тогда
		Возврат "xs";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActInventoryABInfo")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActInventoryF1F2Info") Тогда
		Возврат "iab";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ProductRef")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ProductRef_v2") Тогда
		Возврат "pref";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ClientRef")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ClientRef_v2") Тогда
		Возврат "oref";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01") Тогда
		Возврат "ns";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActTTNSingle")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActTTNSingle_v2") Тогда
		Возврат "wa";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActChargeOn")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActChargeOn_v2")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActChargeOnShop_v2") Тогда
		Возврат "ainp";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActWriteOff")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActWriteOff_v2")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ActWriteOffShop_v2") Тогда
		Возврат "awr";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/QueryParameters")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/RequestRepealWB")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/RequestRepealACO")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/RequestRepealAWO")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/InfoVersionTTN") Тогда
		Возврат "qp";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/QueryFormAB")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/QueryFormF1F2") Тогда
		Возврат "qf";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ConfirmTicket")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/ConfirmRepealWB") Тогда
		Возврат "wt";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/TTNSingle")
		ИЛИ ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/TTNSingle_v2") Тогда
		Возврат "wb";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/TransferToShop") Тогда
		Возврат "tts";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/TransferFromShop") Тогда
		Возврат "tfs";
		
	ИначеЕсли ВРег(ПространствоИмен) = ВРег("http://fsrar.ru/WEGAIS/CommonEnum") Тогда
		Возврат "unqualified_element";
		
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Возвращает вид документа по строковому типу ЕГАИС.
//
Функция ВидДокументаПоТипуЕГАИС(ТипЕГАИС) Экспорт
	
	Если ВРег(ТипЕГАИС) = ВРег("WayBillAct") ИЛИ ВРег(ТипЕГАИС) = ВРег("WayBillAct_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.АктПодтвержденияТТН;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ActChargeOn") ИЛИ ВРег(ТипЕГАИС) = ВРег("ActChargeOn_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ActChargeOnShop_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ActWriteOff") ИЛИ ВРег(ТипЕГАИС) = ВРег("ActWriteOff_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра1;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ActWriteOffShop_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра2;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("TransferFromShop") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ВозвратИзРегистра2;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("QueryAP") ИЛИ ВРег(ТипЕГАИС) = ВРег("QueryAP_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("RequestRepealACO") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаПостановкиНаБаланс;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("RequestRepealAWO") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаСписания;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("RequestRepealWB") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТТН;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("QueryClients") ИЛИ ВРег(ТипЕГАИС) = ВРег("QueryClients_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросОрганизаций;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("QueryRests") ИЛИ ВРег(ТипЕГАИС) = ВРег("QueryRests_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("QueryRestsShop_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре2;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("QueryFormA") ИЛИ ВРег(ТипЕГАИС) = ВРег("QueryFormF1") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросСправки1;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("QueryFormB") ИЛИ ВРег(ТипЕГАИС) = ВРег("QueryFormF2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросСправки2;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("QueryResendDoc") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ЗапросТТН;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("InfoVersionTTN") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ИнформацияОФорматеОбмена;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("Ticket") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведения;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ReplyAP") ИЛИ ВРег(ТипЕГАИС) = ВРег("ReplyAP_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ОтветАлкогольнаяПродукция;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ReplyClient") ИЛИ ВРег(ТипЕГАИС) = ВРег("ReplyClient_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ОтветОрганизации;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ReplyRests") ИЛИ ВРег(ТипЕГАИС) = ВРег("ReplyRests_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ОтветОстаткиВРегистре1;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ReplyRestsShop_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ОтветОстаткиВРегистре2;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("TransferToShop") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ПередачаВРегистр2;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ConfirmTicket") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ПодтверждениеАктаРасхожденийТТН;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ConfirmRepealWB") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ПодтверждениеЗапросаНаОтменуПроведенияТТН;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("TTNInformBReg") ИЛИ ВРег(ТипЕГАИС) = ВРег("TTNInformF2Reg") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.РегистрацияСправокПоТТН;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ReplyFormA") ИЛИ ВРег(ТипЕГАИС) = ВРег("ReplyForm1") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.Справка1;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("ReplyFormB") ИЛИ ВРег(ТипЕГАИС) = ВРег("ReplyForm2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.Справка2;
		
	ИначеЕсли ВРег(ТипЕГАИС) = ВРег("WayBill") ИЛИ ВРег(ТипЕГАИС) = ВРег("WayBill_v2") Тогда
		Возврат Перечисления.ВидыДокументовЕГАИС.ТТН;
		
	Иначе
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли