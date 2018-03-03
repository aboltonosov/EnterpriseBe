﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы 				 = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия", 				 ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	РежимРаботы.Вставить("ИспользоватьПроизводство",     ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске.
	Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = РежимРаботы.КлиентСерверный И РежимРаботы.ЭтоАдминистраторСистемы И НЕ РежимРаботы.БазоваяВерсия;
	Элементы.ГруппаДатыЗапретаЗагрузки.Видимость = НЕ РежимРаботы.БазоваяВерсия;
	
	Если РежимРаботы.БазоваяВерсия Тогда
		Элементы.ОписаниеРаздела.Заголовок =
			НСтр("ru = 'Настройка синхронизации данных с другими программами.'");
	КонецЕсли;
	
	Если РежимРаботы.ИспользоватьПроизводство Тогда
		Элементы.ИспользоватьСинхронизациюДанных.РасширеннаяПодсказка.Заголовок = 
			НСтр("ru = 'Синхронизация данных с другими программами, например с 1С:Зарплата и управление персоналом, редакция 2.5.'");
	КонецЕсли;
	
	Если РежимРаботы.МодельСервиса Тогда
		Элементы.ОписаниеРаздела.Заголовок = НСтр("ru = 'Синхронизация данных с моими приложениями.'");
		Элементы.ИспользоватьДатыЗапретаЗагрузки.РасширеннаяПодсказка.Заголовок =
			НСтр("ru = 'Запрет загрузки данных прошлых периодов из других приложений.
			           |Не влияет на загрузку данных из автономных рабочих мест.'");
		
		Элементы.ГруппаИспользоватьСинхронизациюДанных.Видимость = Ложь;
		Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = Ложь;
		
		Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Заголовок = НСтр("ru = 'Префикс в этой программе'");
		
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		Элементы.ГруппаПрефиксУзлаРаспределеннойИнформационнойБазы.Видимость = Ложь;
		Элементы.ГруппаНастройкиСинхронизацииДанных.Видимость = Ложь;
		Элементы.ГруппаЗагрузкаДанныхEnterpriseData.Видимость = Ложь;
	Иначе
		МассивДоступныхВерсий = Новый Соответствие;
		МодульОбменДаннымиПереопределяемый = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиПереопределяемый");
		МодульОбменДаннымиПереопределяемый.ПриПолученииДоступныхВерсийФормата(МассивДоступныхВерсий);
		Элементы.ГруппаЗагрузкаДанныхEnterpriseData.Видимость = ?(МассивДоступныхВерсий.Количество() = 0, Ложь, Истина);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзмененияСлужебный = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзмененияСлужебный");
		СвойстваРазделов = МодульДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
		Элементы.ГруппаДатыЗапретаЗагрузки.Видимость = СвойстваРазделов.ДатыЗапретаЗагрузкиВнедрены;
	Иначе
		Элементы.ГруппаДатыЗапретаЗагрузки.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксУзлаРаспределеннойИнформационнойБазыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляWindowsПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляLinuxПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиСинхронизацииДанных(Команда)
	
	Если РежимРаботы.МодельСервиса Тогда
		ИмяОткрываемойФормы = "ОбщаяФорма.СинхронизацияДанныхВМоделиСервиса";
	Иначе
		ИмяОткрываемойФормы = "ОбщаяФорма.СинхронизацияДанных";
	КонецЕсли;
	ОткрытьФорму(ИмяОткрываемойФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРазрешенияПрофилейБезопасности(Элемент)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбновитьРазрешенияПрофилейБезопасностиЗавершение", ЭтотОбъект, Элемент);
	
	МассивЗапросов = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Элемент.Имя);
	
	Если МассивЗапросов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
		МассивЗапросов, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаСервере
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(ИмяКонстанты)
	
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() = КонстантаЗначение Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользоватьСинхронизациюДанных" Тогда
		
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		Если КонстантаЗначение Тогда
			Запрос = МодульОбменДаннымиСервер.ЗапросНаИспользованиеВнешнихРесурсовПриВключенииОбмена();
		Иначе
			Запрос = МодульОбменДаннымиСервер.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов();
		КонецЕсли;
		Возврат Запрос;
		
	Иначе
		
		МенеджерЗначения = КонстантаМенеджер.СоздатьМенеджерЗначения();
		ИдентификаторКонстанты = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МенеджерЗначения.Метаданные());
		
		Если ПустаяСтрока(КонстантаЗначение) Тогда
			
			Запрос = РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(ИдентификаторКонстанты);
			
		Иначе
			
			Разрешения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(КонстантаЗначение, Истина, Истина));
			Запрос = РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения, ИдентификаторКонстанты);
			
		КонецЕсли;
		
		Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запрос);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьРазрешенияПрофилейБезопасностиЗавершение(Результат, Элемент) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
	
		Подключаемый_ПриИзмененииРеквизита(Элемент);
		
	Иначе
		
		ЭтотОбъект.Прочитать();
	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбменССайтом"
		И НаборКонстант.ИспользоватьОбменССайтом
		И НЕ НаборКонстант.ИспользоватьДополнительныеРеквизитыИСведения Тогда
		НаборКонстант.ИспользоватьДополнительныеРеквизитыИСведения = Истина;
		СохранитьЗначениеРеквизита("НаборКонстант.ИспользоватьДополнительныеРеквизитыИСведения");
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДатыЗапретаЗагрузки" Или РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		
		Элементы.ГруппаДатыЗапретаЗагрузкиНастройка.Доступность =
			НаборКонстант.ИспользоватьДатыЗапретаЗагрузки;
	КонецЕсли;
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСинхронизациюДанных" Или РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		Элементы.ОткрытьРеестрНормативноСправочнойИнформации.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ОткрытьРеестрУчетныхДанных.Доступность 				 = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.НастройкиСинхронизацииДанных.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаДатыЗапретаЗагрузки.Доступность    = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.РезультатыСинхронизацииДанных.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаВременныеКаталогиКластераСерверов.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбменССайтом" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОткрытьУзлыОбменаССайтами.Доступность = НаборКонстант.ИспользоватьОбменССайтом;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменССайтамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУзлыОбменаССайтами(Команда)
	ОткрытьФорму("ПланОбмена.ОбменССайтом.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРеестрНормативноСправочнойИнформации(Команда)
	ОткрытьФорму("Отчет.РеестрНормативноСправочнойИнформации.Форма", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРеестрУчетныхДанных(Команда)
	ОткрытьФорму("Отчет.РеестрУчетныхДанных.Форма", , ЭтаФорма);
КонецПроцедуры

#КонецОбласти
