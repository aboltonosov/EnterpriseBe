﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство("ВариантПериода") Тогда
			Период.Вариант = СтруктураБыстрогоОтбора.ВариантПериода;
		Иначе
			Период.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ТоварыПереданныеСоздатьОтчетКомиссионераОПродажах.Видимость = 
		ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомиссионера);
	Элементы.ТоварыПереданныеСоздатьОтчетКомиссионераОСписании.Видимость = 
		ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомиссионераОСписании);
		
	Элементы.ТоварыПереданныеОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	УстановитьПараметрыДинамическихСписков();
	
	УстановитьТекущуюСтраницу();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если Не ПроверкаКонтрагентовВызовСервераПовтИсп.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами 
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(Отказ, СтандартнаяОбработка, ПараметрыПриСозданииНаСервере);
	// Конец подсистема "ОбменСКонтрагентами".
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
	// Подсистема "ОбменСКонтрагентами".
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(ПодключаемоеОборудованиеУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ОтчетКомиссионера"
	 ИЛИ ИмяСобытия = "Запись_ОтчетКомиссионераОСписании" Тогда
		Элементы.ТоварыПереданные.Обновить();
	КонецЕсли;
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец подсистема "ОбменСКонтрагентами".

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Комиссионер", Комиссионер);
		
		Если СтруктураБыстрогоОтбора.Свойство("ВариантПериода") Тогда
			Период.Вариант = СтруктураБыстрогоОтбора.ВариантПериода;
		Иначе
			Период.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
		КонецЕсли;
		
		Настройки.Удалить("Комиссионер");
		Настройки.Удалить("Период.Вариант");
	Иначе
		Комиссионер = Настройки.Получить("Комиссионер");
		Вариант = Настройки.Получить("Период.Вариант");
		Если Вариант <> Неопределено Тогда
			Период.Вариант = Вариант;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтборДинамическихСписков();
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомиссионерПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаКомиссионеры Тогда
		Элементы.ТоварыПереданные.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписков

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УправлениеПечатьюКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура СоздатьОтчетКомиссионераОПродажах(Команда)
	
	Строка = Элементы.ТоварыПереданные.ТекущиеДанные;
	Если Строка <> Неопределено Тогда
		СтруктураПараметры = СтруктураПараметровОтчетаКомиссионера(Строка);
		ОткрытьФорму("Документ.ОтчетКомиссионера.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	Иначе
		ОткрытьФорму("Документ.ОтчетКомиссионера.ФормаОбъекта", , Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОтчетКомиссионераОСписании(Команда)
	
	Строка = Элементы.ТоварыПереданные.ТекущиеДанные;
	Если Строка <> Неопределено Тогда
		СтруктураПараметры = СтруктураПараметровОтчетаКомиссионера(Строка);
		ОткрытьФорму("Документ.ОтчетКомиссионераОСписании.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	Иначе
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Команда не может быть выполнена для указанного объекта.'"));
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	УправлениеПечатьюКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетКомиссионера.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетКомиссионераОСписании.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		ПоказатьЗначение(Неопределено, Ссылка);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	ДатаОстатков = ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, '00010101');
	
	Если ЗначениеЗаполнено(ДатаОстатков) Тогда
		Граница = Новый Граница(КонецДня(ДатаОстатков), ВидГраницы.Включая);
	Иначе
		Граница = ДатаОстатков;
	КонецЕсли;
	
	ТоварыПереданные.Параметры.УстановитьЗначениеПараметра("Граница", Граница);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Партнер",
		Комиссионер,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Комиссионер));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ТоварыПереданные,
		"АналитикаУчетаНоменклатуры.Склад",
		Комиссионер,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Комиссионер));
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураПараметровОтчетаКомиссионера(Строка)
	
	СтруктураОснование = Новый Структура;
	СтруктураОснование.Вставить("Организация", Строка.Организация);
	СтруктураОснование.Вставить("Партнер", Строка.Комиссионер);
	СтруктураОснование.Вставить("Соглашение", Строка.Соглашение);
	СтруктураОснование.Вставить("НачалоПериода", Период.ДатаНачала);
	СтруктураОснование.Вставить("КонецПериода", Период.ДатаОкончания);
	СтруктураОснование.Вставить("ПоРезультатамИнвентаризации", Истина);
	СтруктураОснование.Вставить("ЗаполнятьПоСоглашению", Истина);
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", СтруктураОснование);
	
	Возврат СтруктураПараметры;
	
КонецФункции

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьТекущуюСтраницу()
	
	ИмяТекущейСтраницы = "";
	
	Если Параметры.Свойство("ИмяТекущейСтраницы", ИмяТекущейСтраницы) Тогда
		Если ЗначениеЗаполнено(ИмяТекущейСтраницы) Тогда
			ТекущийЭлемент = Элементы[ИмяТекущейСтраницы];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
