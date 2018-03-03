﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность 
//             электронного документооборота с контролирующими органами". 
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Проверка наличия подключения к интернету
// (см. http://technet.microsoft.com/en-us/library/cc766017(WS.10).aspx)
//
// Возвращаемое значение:
// 	Булево - признак наличия подключения к интернету.
//
Функция ЕстьПодключениеКИнтернету() Экспорт
	
	Соединение = Новый HTTPСоединение("www.msftncsi.com",,,,, 10);
	Запрос = Новый HTTPЗапрос("/ncsi.txt");
	Попытка
		Ответ = Соединение.Получить(Запрос);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Если Ответ.КодСостояния = 200
		И Ответ.ПолучитьТелоКакСтроку() = "Microsoft NCSI" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

// Устанавливает соединение с сервером Интернета по протоколу http(s).
//
// Параметры:
//  URL                 - Строка - url сервера в формате [Протокол://]<Сервер>/.
//  ПараметрыСоединения - Структуруа - дополнительные параметры для "тонкой" настройки.
//    * Таймаут - Число - определяет время ожидания осуществляемого соединения и операций, в секундах.
//
Функция СоединениеССерверомИнтернета(URL, ПараметрыСоединения = Неопределено) Экспорт

	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	Схема = ?(ЗначениеЗаполнено(СтруктураURI.Схема), СтруктураURI.Схема, "http");
	Прокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси(Схема);
	
	Таймаут = 30;
	Если ТипЗнч(ПараметрыСоединения) = Тип("Структура") Тогда
		Если ПараметрыСоединения.Свойство("Таймаут") Тогда
			Таймаут = ПараметрыСоединения.Таймаут;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		Соединение = Новый HTTPСоединение(
			СтруктураURI.Хост,
			СтруктураURI.Порт,
			СтруктураURI.Логин,
			СтруктураURI.Пароль, 
			Прокси,
			Таймаут,
			?(НРег(Схема) = "http", Неопределено, Новый ЗащищенноеСоединениеOpenSSL));
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();	
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронный документооборот с контролирующими органами. Установление соединения с сервером интернета'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

#КонецОбласти