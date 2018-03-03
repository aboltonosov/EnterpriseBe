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
	
	//++ НЕ УТ
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПроизводство");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПроизводствоНаСтороне");
	//-- НЕ УТ
	ВнешниеРодительскиеКонстанты.Вставить("ВестиУчетМаркировкиПродукцииВГИСМ");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПолнотекстовыйПоиск");
	
	УправлениеТорговлей = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	БазоваяВерсия = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("УправлениеПредприятием",	 	 НЕ УправлениеТорговлей);
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Элементы.ГруппаИспользоватьСертификаты.Видимость = НЕ БазоваяВерсия;
	
	Элементы.ИспользоватьУчетДрагоценныхМатериалов.Видимость = Ложь;
	//++ НЕ УТ
	Элементы.ИспользоватьУчетДрагоценныхМатериалов.Видимость = Истина;
	//-- НЕ УТ
	
	Элементы.НастройкаМиграцииШтрихкодов.Видимость = УправлениеТорговлей И НЕ БазоваяВерсия;
	
	Если РежимРаботы.ЭтоАдминистраторСистемы Тогда
		ОпределитьНастройкиРегламентногоЗаданияОчисткаСегментов();
	Иначе
		Элементы.НастроитьОчисткуСегментов.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ТекущийОбъект.ИспользоватьСтандартныйПоискПриПодбореТоваров Тогда
		ВариантПоиска = "Стандартный"
	Иначе
		ВариантПоиска = "Расширенный"
	КонецЕсли;
	
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
Процедура ЕдиницаИзмеренияВесаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияЛинейныхРазмеровПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПлощадиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияОбъемаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЕдиницыИзмеренияДляОтчетовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВариантПоиска1ПриИзменении(Элемент)
	Если ВариантПоиска = "Стандартный" Тогда
		НаборКонстант.ИспользоватьСтандартныйПоискПриПодбореТоваров = Истина;
	Иначе
		НаборКонстант.ИспользоватьСтандартныйПоискПриПодбореТоваров = Ложь;
	КонецЕсли;	
	Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьСтандартныйПоискПриПодбореТоваров, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВариантПоиска2ПриИзменении(Элемент)
	Если ВариантПоиска = "Стандартный" Тогда
		НаборКонстант.ИспользоватьСтандартныйПоискПриПодбореТоваров = Истина;
	Иначе
		НаборКонстант.ИспользоватьСтандартныйПоискПриПодбореТоваров = Ложь;
	КонецЕсли;	
	Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьСтандартныйПоискПриПодбореТоваров, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура МаксимальноеКоличествоЭлементовВДеревеОтборовНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ДопустимоеОтклонениеПриОкругленииКоличестваПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьУникальностьРабочегоНаименованияНоменклатурыИХарактеристикПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьХарактеристикиНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУпаковкиНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСерииНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКачествоТоваровПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбобщенныйУчетНекачественныхТоваровПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРасширеннуюФормуПодбораКоличестваИВариантовОбеспеченияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНоменклатуруПоставщиковПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНоменклатуруПродаваемуюСовместноПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьУникальностьНоменклатурыПоСочетаниюЗначенийРеквизитовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьМногооборотнуюТаруПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантПредлагатьДополнитьДокументыМногооборотнойТаройПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСертификатыНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетДрагоценныхМатериаловПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНаборыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоВидовНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Оповестить("Запись_МножествоВидовНоменклатуры");
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеКлассификаторовНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтоматическоеЗакрытиеСтрокЗаказовМерныхТоваровПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	ИспользоватьАвтоматическоеЗакрытиеСтрокЗаказовМерныхТоваров =
		НаборКонстант.ИспользоватьАвтоматическоеЗакрытиеСтрокЗаказовМерныхТоваров;
	
	Изменения = Новый Структура("Использование", ИспользоватьАвтоматическоеЗакрытиеСтрокЗаказовМерныхТоваров);
	РегламентныеЗаданияСохранитьПриИзменении("КорректировкаСтрокЗаказовМерныхТоваров", Изменения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСегментыНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьНастройкиНоменклатурыПродаваемойСовместно(Команда)
	ОткрытьФорму("РегистрСведений.НоменклатураПродаваемаяСовместно.Форма.НастройкаПоискаАссоциаций",,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЕдиницыИзмерения(Команда)
	Отбор = Новый Структура;
	Отбор.Вставить("Владелец",ПредопределенноеЗначение("Справочник.НаборыУпаковок.БазовыеЕдиницыИзмерения"));
	ПараметрыФормыСправочника = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.УпаковкиЕдиницыИзмерения.ФормаСписка",
		ПараметрыФормыСправочника,
		ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПрефиксовВнутреннихШтрихкодовEAN13(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаПрефиксовВнутреннихШтрихкодовEAN13");	
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеОчисткиСегментов(Команда)
	
	РегламентныеЗаданияГиперссылкаНажатие("ОчисткаСегментов");
	
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
		
		//++ НЕ УТ
		Если КонстантаИмя = "ИспользоватьУчетДрагоценныхМатериалов" И КонстантаЗначение Тогда
			Справочники.ДрагоценныеМатериалы.ЗаполнитьПредопределенныеДрагоценныеМатериалы();
		КонецЕсли;
		//-- НЕ УТ
		
		Если КонстантаИмя = "ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров" Тогда
			
			Константы.ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Установить(КонстантаЗначение > 0);
			Если КонстантаЗначение = 0 Тогда
				Константы.ИспользоватьАвтоматическоеЗакрытиеСтрокЗаказовМерныхТоваров.Установить(Ложь);
				НаборКонстант.ИспользоватьАвтоматическоеЗакрытиеСтрокЗаказовМерныхТоваров = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУпаковкиНоменклатуры" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьУпаковкиНоменклатуры;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьУпаковкиНоменклатуры, ЗначениеКонстанты);
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьХарактеристикиНоменклатуры" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьХарактеристикиНоменклатуры;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьХарактеристикиНоменклатуры, ЗначениеКонстанты);
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСерииНоменклатуры" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСерииНоменклатуры;
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьСерииНоменклатуры, НаборКонстант.ИспользоватьСерииНоменклатуры);
		
		ИспользоватьОрдерныеСклады = Константы.ИспользоватьОрдерныеСклады.Получить();
		Элементы.ГруппаКомментарийСерииНаОрдерныхСкладах.Видимость = ЗначениеКонстанты И Не ИспользоватьОрдерныеСклады;
		Элементы.ГруппаКомментарийНевозможноОтключениеСерий.Видимость = НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
		Элементы.ИспользоватьСерииНоменклатуры.Доступность = Не НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьКачествоТоваров" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьКачествоТоваров;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьКачествоТоваров, ЗначениеКонстанты);
		Элементы.ИспользоватьОбобщенныйУчетНекачественныхТоваров.Доступность = ЗначениеКонстанты;
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьМногооборотнуюТару" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоВидовНоменклатуры"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьМногооборотнуюТару;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьМногооборотнуюТару, ЗначениеКонстанты);
			
		Элементы.ПредлагатьДополнитьДокументыМногооборотнойТарой.Доступность = ЗначениеКонстанты;
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНоменклатуруПродаваемуюСовместно" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОткрытьНастройкиНоменклатурыПродаваемойСовместно.Доступность = НаборКонстант.ИспользоватьНоменклатуруПродаваемуюСовместно;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСертификатыНоменклатуры" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСертификатыНоменклатуры;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНаборы" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоВидовНоменклатуры"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНаборы;
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьНаборы, ЗначениеКонстанты);
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоВидовНоменклатуры" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНесколькоВидовНоменклатуры;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьНесколькоВидовНоменклатуры, ЗначениеКонстанты);
			
		Элементы.ИспользоватьНаборы.Доступность = ЗначениеКонстанты;
		Элементы.ИспользоватьМногооборотнуюТару.Доступность = ЗначениеКонстанты;
		Элементы.ПредлагатьДополнитьДокументыМногооборотнойТарой.Доступность = ЗначениеКонстанты и НаборКонстант.ИспользоватьМногооборотнуюТару;
		
		Элементы.ГруппаКомментарийИспользоватьНесколькоВидов.Видимость = НЕ ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
		
		//++ НЕ УТ
		Элементы.ГруппаКомментарийИспользоватьНесколькоВидов.Видимость = НаборКонстант.ИспользоватьПроизводство
			ИЛИ НаборКонстант.ИспользоватьПроизводствоНаСтороне ИЛИ НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
			
		Элементы.ИспользоватьНесколькоВидовНоменклатуры.Доступность = Не НаборКонстант.ИспользоватьПроизводство И
			Не НаборКонстант.ИспользоватьПроизводствоНаСтороне И Не НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
			
		Элементы.ГруппаКомментарийИспользоватьНесколькоВидовУТ.Видимость = Ложь;
		//-- НЕ УТ
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.КонтролироватьУникальностьНоменклатурыПоСочетаниюЗначенийРеквизитов" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.КонтролироватьУникальностьНоменклатурыПоСочетаниюЗначенийРеквизитов;
		Элементы.ГруппаКомментарийКонтролироватьУникальность.Видимость = НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
		Элементы.КонтролироватьУникальностьНоменклатурыПоСочетаниюЗначенийРеквизитов.Доступность = Не НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
	КонецЕсли;
	
	Если  РеквизитПутьКДанным = "" Тогда
		
		Элементы.ГруппаКомментарийИспользоватьКлассификаторыНоменклатурыУТ.Видимость = 
			НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
			
		Элементы.ИспользованиеКлассификаторовНоменклатуры.Доступность = 
			Не НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
			
		Элементы.ГруппаКомментарийИспользоватьКлассификаторыНоменклатуры.Видимость = Ложь;
		
	КонецЕсли;
	
	//++ НЕ УТ
	Если РеквизитПутьКДанным = "" Тогда
		
		Элементы.ГруппаКомментарийИспользоватьКлассификаторыНоменклатуры.Видимость = 
			НаборКонстант.ИспользоватьУведомленияОКонтролируемыхСделках 
			Или НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
				
		Элементы.ИспользованиеКлассификаторовНоменклатуры.Доступность = 
			Не НаборКонстант.ИспользоватьУведомленияОКонтролируемыхСделках 
			И Не НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
		
		Элементы.ГруппаКомментарийИспользоватьКлассификаторыНоменклатурыУТ.Видимость = Ложь;
		
	КонецЕсли;
	//-- НЕ УТ
	
	Если РеквизитПутьКДанным = "НаборКонстант.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = Константы.ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить();
		Элементы.ИспользоватьАвтоматическоеЗакрытиеСтрокЗаказовМерныхТоваров.Доступность = ЗначениеКонстанты;
	КонецЕсли;
	
		Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСегментыНоменклатуры" 
		Или РеквизитПутьКДанным = "" Тогда
		
		Элементы.НастроитьОчисткуСегментов.Доступность = НаборКонстант.ИспользоватьСегментыНоменклатуры;
		
	КонецЕсли;													 
													 
	Элементы.ИспользоватьПолнотекстовыйПоискПриПодбореТоваров.Доступность = (НаборКонстант.ИспользоватьПолнотекстовыйПоиск = 1);
	Элементы.ГруппаКомментарийИспользоватьПолнотекстовыйПоискПриПодбореТоваров.Видимость = НЕ Элементы.ИспользоватьПолнотекстовыйПоискПриПодбореТоваров.Доступность;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура РегламентныеЗаданияСохранитьПриИзменении(НаименованиеЗадания, Изменения)
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания[НаименованиеЗадания]);
	РегламентноеЗаданиеИдентификатор = РегламентныеЗаданияСервер.УникальныйИдентификатор(РегламентноеЗадание);
	
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегламентноеЗаданиеИдентификатор, Изменения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгружатьВнутренниеШтрихкодыШтучныхТоваровПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФасовкуВесовогоТовараПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксШтрихкодовУзлаРИБПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИспользоватьПолнотекстовыйПоискПриПодбореТоваровПриИзменении(Элемент)
	
	ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗадания

&НаСервере
Процедура ОпределитьНастройкиРегламентногоЗаданияОчисткаСегментов()
	
	РегламентноеЗадание = РегламентныеЗаданияНайтиПредопределенное("ОчисткаСегментов");
	Если РегламентноеЗадание <> Неопределено Тогда
		ОчисткаСегментовИдентификатор = РегламентноеЗадание.УникальныйИдентификатор;
		ОчисткаСегментовИспользование = РегламентноеЗадание.Использование;
		ОчисткаСегментовРасписание    = РегламентноеЗадание.Расписание;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияГиперссылкаНажатие(ПрефиксРеквизитов)
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Идентификатор", ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"]);
	ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
	
	РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения)
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание]);
	Диалог.Показать(Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	
	Если Расписание = Неопределено Тогда
		Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
			ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание] = Расписание;
	
	Изменения = Новый Структура("Расписание", Расписание);
	Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
		ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Истина;
		Изменения.Вставить("Использование", Истина);
	КонецЕсли;
	РегламентныеЗаданияСохранить(ПараметрыВыполнения.Идентификатор, Изменения, ПараметрыВыполнения.ИмяРеквизитаРасписание);
	
КонецПроцедуры

&НаСервере
Процедура РегламентныеЗаданияСохранить(УникальныйИдентификатор, Изменения, РеквизитПутьКДанным)
	РегламентноеЗадание = РегламентныеЗаданияСервер.Задание(УникальныйИдентификатор);
	ЗаполнитьЗначенияСвойств(РегламентноеЗадание, Изменения);
	РегламентноеЗадание.Записать();
	
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция РегламентныеЗаданияНайтиПредопределенное(ИмяПредопределенного)
	МетаданныеПредопределенного = Метаданные.РегламентныеЗадания.Найти(ИмяПредопределенного);
	Если МетаданныеПредопределенного = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат РегламентныеЗаданияСервер.Задание(МетаданныеПредопределенного);
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецОбласти
