﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей (БРО)".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ПроверитьВозможностьВыполненияОперацииНаСервере(Знач ПараметрыАутентификации) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат "ВыполнениеРазрешено";
	Иначе
		Если НЕ ЗначениеЗаполнено(ПараметрыАутентификации)
			ИЛИ (ЗначениеЗаполнено(ПараметрыАутентификации) И ПараметрыАутентификации.Пароль = "") Тогда
			УстановитьПривилегированныйРежим(Истина);
			ПараметрыАутентификации = ПараметрыАутентификацииНаСайте();
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыАутентификации) Тогда
			Возврат "ПараметрыАутентификацииНеЗаполнены";
		Иначе
			Результат = ПараметрыАутентификацииКорректные(ПараметрыАутентификации);
			Если Результат = "НекорректноеИмяПользователяИлиПароль" Тогда
				Возврат "ПараметрыАутентификацииУказаныНеВерно";
			ИначеЕсли Результат = "АутентификацияВыполнена" Тогда
				Возврат "ВыполнениеРазрешено";
			ИначеЕсли Результат = "НеизвестнаяОшибка" Тогда
				Возврат "НеизвестнаяОшибкаПриПроверке";
			Иначе
				Возврат "ВыполнениеЗапрещено";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыАутентификацииКорректные(ПараметрыАутентификацииНаСайте, ОписаниеОшибки = "")
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте)
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте.Логин)
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте.Пароль) Тогда
		Результат = "НекорректноеИмяПользователяИлиПароль";
		Возврат Результат;
	КонецЕсли;
	
	Результат = "НеизвестнаяОшибка";
	Билет = "";
	Попытка
		ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
		ПараметрыПодключения.АдресWSDL = "https://login.1c.ru/api/public/ticket?wsdl";
		ПараметрыПодключения.URIПространстваИмен = "http://api.cas.jasig.org/";
		ПараметрыПодключения.ИмяСервиса = "TicketApiImplService";
		ПараметрыПодключения.ИмяТочкиПодключения = "TicketApiImplPort";
		ПараметрыПодключения.ИмяПользователя = ПараметрыАутентификацииНаСайте.Логин;
		ПараметрыПодключения.Пароль = ПараметрыАутентификацииНаСайте.Пароль;
		ПараметрыПодключения.Таймаут = 5;
		
		ВебСервис = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
		
		Билет = ВебСервис.getTicket(
			ПараметрыАутентификацииНаСайте.Логин,
			ПараметрыАутентификацииНаСайте.Пароль,
			"its.1c.ru");
			
		Если ЗначениеЗаполнено(Билет) Тогда
			Результат = "АутентификацияВыполнена";
		КонецЕсли;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		Если СтрНайти(КраткоеПредставлениеОшибки, "IncorrectLoginOrPasswordApiException") > 0 Тогда
			Результат = "НекорректноеИмяПользователяИлиПароль";
		КонецЕсли;
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'БРО. Интернет-поддержка пользователей. getTicket'"),
		    УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыАутентификацииНаСайте() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		Возврат МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	Иначе
		ВызватьИсключение НСтр("ru = 'Сервис интернет-поддержки пользователей не подключен.'");
	КонецЕсли;
	
КонецФункции

#КонецОбласти