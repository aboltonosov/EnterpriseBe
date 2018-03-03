﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

&НаКлиенте
Перем ОбновитьИнтерфейс;

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
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПодразделения");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьНесколькоОрганизаций");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьБюджетирование");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ИспользоватьЖурналПлатежей = НаборКонстант.ИспользоватьЖурналПлатежей;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
	//++ НЕ УТ
	ДополнитьТекстРасширеннойПодсказкиКонтролироватьЛимитыКА();
	//-- НЕ УТ
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьДоговорыКредитовИДепозитовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоКассПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаявкиНаРасходованиеДенежныхСредствПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьЗаказыПоставщикам И НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Истина);
		
	Иначе
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Ложь);
		
	КонецЕсли;

	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоРасчетныхСчетовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛимитыРасходаДенежныхСредствПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьПревышениеЛимитовРасходаДенежныхСредствПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЖурналПлатежейПриИзменении(Элемент)
	
	НаборКонстант.ИспользоватьЖурналПлатежей = ИспользоватьЖурналПлатежей;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуПлатежнымиКартамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДоверенностиНаПолучениеТМЦПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыАвансовыхОтчетовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьВыдачуПодОтчетВРазрезеЦелейПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоддержкаПлатежейВСоответствииС275ФЗПриИзменении(Элемент)
	//++ НЕ УТ
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	//-- НЕ УТ
	
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиПодтверждающихДокументовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//++ НЕ УТ
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите каталог для сохранения архивов подтверждающих документов'");
	ДиалогОткрытияФайла.Каталог = Элементы.КаталогВыгрузкиПодтверждающихДокументов.ТекстРедактирования;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		НаборКонстант.КаталогВыгрузкиПодтверждающихДокументов = ДиалогОткрытияФайла.Каталог;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	//-- НЕ УТ
	
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаПодтверждающегоДокументаПриИзменении(Элемент)
	//++ НЕ УТ
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	//-- НЕ УТ
	
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаАрхиваПодтверждающихДокументовПриИзменении(Элемент)
	//++ НЕ УТ
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	//-- НЕ УТ
	
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьТипыПлатежей275ФЗ(Команда)
	
	// ++ НЕ УТ
	ОткрытьФорму("Справочник.ТипыПлатежейФЗ275.ФормаСписка");
	// -- НЕ УТ
	
	Возврат; // В УТ обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыПодтверждающихДокументов(Команда)
	
	// ++ НЕ УТ
	ОткрытьФорму("Справочник.ВидыПодтверждающихДокументов.ФормаСписка");
	// -- НЕ УТ
	
	Возврат; // В УТ обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

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

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

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
		Если РеквизитПутьКДанным = "ИспользоватьЖурналПлатежей" Тогда
			КонстантаИмя = "ИспользоватьЖурналПлатежей";
			НаборКонстант.ИспользоватьЖурналПлатежей = Булево(ИспользоватьЖурналПлатежей);
		КонецЕсли;
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
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств" Тогда
		ИспользоватьЖурналПлатежей = НаборКонстант.ИспользоватьЖурналПлатежей;
	КонецЕсли;
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")

	Если РеквизитПутьКДанным = "" Тогда
		
		Элементы.ИспользоватьНесколькоКасс.Доступность = НЕ НаборКонстант.ИспользоватьНесколькоОрганизаций;
		Элементы.ИспользоватьНесколькоРасчетныхСчетов.Доступность = НЕ НаборКонстант.ИспользоватьНесколькоОрганизаций;
	
		//++ НЕ УТ
		ИспользоватьБюджетирование = ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование");
		
		Элементы.ГруппаИспользоватьЛимитыРасходаДенежныхСредств.Видимость = НЕ ИспользоватьБюджетирование;
		Элементы.ГруппаИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям.Видимость = НЕ ИспользоватьБюджетирование;
		Элементы.ГруппаИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям.Видимость = НЕ ИспользоватьБюджетирование;
		
		
		
		Элементы.СправочникМоделиБюджетированияОткрытьСписок.Видимость = ИспользоватьБюджетирование;
		//-- НЕ УТ
		
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям.Доступность = НаборКонстант.ИспользоватьПодразделения;
		
		// 4D:ERP для Беларуси, Дмитрий, 07.09.2017 14:06:17 
		// Локализация экранных форм
		// {
		Элементы.ГруппаПоддержка275ФЗ.Видимость = Ложь;
		// }
		// 4D
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоКасс" ИЛИ РеквизитПутьКДанным = "" Тогда
		Если НаборКонстант.ИспользоватьНесколькоКасс Тогда
			Элементы.ГруппаСтраницыИспользоватьНесколькоКасс.ТекущаяСтраница = Элементы.ГруппаНесколькоКасс;
		Иначе
			Элементы.ГруппаСтраницыИспользоватьНесколькоКасс.ТекущаяСтраница = Элементы.ГруппаОднаКасса;
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоРасчетныхСчетов" ИЛИ РеквизитПутьКДанным = "" Тогда
		Если НаборКонстант.ИспользоватьНесколькоРасчетныхСчетов Тогда
			Элементы.ГруппаСтраницыИспользоватьНесколькоРасчетныхСчетов.ТекущаяСтраница = Элементы.ГруппаНесколькоСчетов;
		Иначе
			Элементы.ГруппаСтраницыИспользоватьНесколькоРасчетныхСчетов.ТекущаяСтраница = Элементы.ГруппаОдинСчет;
		КонецЕсли;
	КонецЕсли;

	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств"
	 ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЛимитыРасходаДенежныхСредств"
	 ИЛИ РеквизитПутьКДанным = "" Тогда
		 
		ИспользоватьЛимиты = НаборКонстант.ИспользоватьЛимитыРасходаДенежныхСредств;
		
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредств.Доступность = НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
		
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям.Доступность = ИспользоватьЛимиты И НаборКонстант.ИспользоватьНесколькоОрганизаций;
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям.Доступность = ИспользоватьЛимиты И НаборКонстант.ИспользоватьПодразделения;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование") = Ложь Тогда
			Элементы.КонтролироватьПревышениеЛимитовРасходаДенежныхСредств.Доступность = ИспользоватьЛимиты;
		Иначе
			Элементы.КонтролироватьПревышениеЛимитовРасходаДенежныхСредств.Доступность = НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ИспользоватьЖурналПлатежей.Доступность = Не НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
		
	КонецЕсли;
	
	//++ НЕ УТ
	Если РеквизитПутьКДанным = "НаборКонстант.ПоддержкаПлатежейВСоответствииС275ФЗ"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОткрытьТипыПлатежей275ФЗ.Доступность = НаборКонстант.ПоддержкаПлатежейВСоответствииС275ФЗ;
		Элементы.ОткрытьВидыПодтверждающихДокументов.Доступность = НаборКонстант.ПоддержкаПлатежейВСоответствииС275ФЗ;
		Элементы.КаталогВыгрузкиПодтверждающихДокументов.Доступность = НаборКонстант.ПоддержкаПлатежейВСоответствииС275ФЗ;
		Элементы.МаксимальныйРазмерФайлаАрхиваПодтверждающихДокументов.Доступность = НаборКонстант.ПоддержкаПлатежейВСоответствииС275ФЗ;
		Элементы.МаксимальныйРазмерФайлаПодтверждающегоДокумента.Доступность = НаборКонстант.ПоддержкаПлатежейВСоответствииС275ФЗ;
	КонецЕсли;
	//-- НЕ УТ
	
	УправлениеТорговлей = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	Элементы.Декорация4.Видимость = Не УправлениеТорговлей;
	Элементы.Декорация5.Видимость = Не УправлениеТорговлей;
	Элементы.ПоддержкаПлатежейВСоответствииС275ФЗ.Видимость = Не УправлениеТорговлей;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Использование)
	
	Константы.ИспользоватьЗаказыПоставщикамИЗаявкиНаРасходованиеДС.Установить(Использование);
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере
Процедура ДополнитьТекстРасширеннойПодсказкиКонтролироватьЛимитыКА()
	
	ИспользоватьБюджетирование = ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование");	
	Если Не ИспользоватьБюджетирование Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗаголовка = Элементы.КонтролироватьПревышениеЛимитовРасходаДенежныхСредств.РасширеннаяПодсказка.Заголовок;
	ТекстЗаголовка = ТекстЗаголовка + НСтр("ru = 'При превышении лимита или если заявка не изменяет ни одну из статей бюджетов запрещается проведение 
			|заявок на расход в статусах ""Согласована"" и ""К оплате"".'");
	
	Элементы.КонтролироватьПревышениеЛимитовРасходаДенежныхСредств.РасширеннаяПодсказка.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры
//-- НЕ УТ

#КонецОбласти

#КонецОбласти
