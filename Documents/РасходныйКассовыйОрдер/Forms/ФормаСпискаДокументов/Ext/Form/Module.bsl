﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ИспользоватьНачислениеЗарплаты = Константы.ИспользоватьНачислениеЗарплаты.Получить();
	ИспользоватьЗаявкиНаРасходованиеДенежныхСредств = ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств");
	ИспользоватьНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	ИспользоватьРозничныеПродажи = ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи");
	//++ НЕ УТ
	ИспользоватьЛизинг = ПолучитьФункциональнуюОпцию("ИспользоватьЛизинг");
	//-- НЕ УТ
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу;
	
	//++ НЕ УТ
	Если ИспользоватьНачислениеЗарплаты Тогда
		ВыплатаЗарплаты.ТекстЗапроса = ТекстЗапросаВыплатаЗарплаты();
	КонецЕсли;
	//-- НЕ УТ
	
	ИнициализироватьСписокОперацийОплаты();
	
	ОписаниеОтборов = Новый Соответствие;
	ОписаниеОтборов.Вставить("Организация", Тип("СправочникСсылка.Организации"));
	ОписаниеОтборов.Вставить("Касса", Тип("СправочникСсылка.Кассы"));
	УправлениеДоступом.НастроитьОтборыДинамическогоСписка(РасходныеКассовыеОрдера, ОписаниеОтборов);
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		РазрешенныеОрганизации = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка("РегистрСведений.ГрафикПлатежей", Тип("СправочникСсылка.Организации"));
		Если РазрешенныеОрганизации <> Неопределено Тогда
			ЗаказыКОплате.Параметры.УстановитьЗначениеПараметра("РазрешенныеЗначенияПоляОрганизация", РазрешенныеОрганизации);
			ЗаявкиКОплате.Параметры.УстановитьЗначениеПараметра("РазрешенныеЗначенияПоляОрганизация", РазрешенныеОрганизации);
		КонецЕсли;
		РазрешенныеКассы = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка("РегистрСведений.ГрафикПлатежей", Тип("СправочникСсылка.Кассы"));
		Если РазрешенныеКассы <> Неопределено Тогда
			РазрешенныеКассы.Добавить(Неопределено);
			ЗаказыКОплате.Параметры.УстановитьЗначениеПараметра("РазрешенныеЗначенияПоляКасса", РазрешенныеКассы);
			ЗаявкиКОплате.Параметры.УстановитьЗначениеПараметра("РазрешенныеЗначенияПоляКасса", РазрешенныеКассы);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПараметрыДинамическихСписков();
	УстановитьОтборДинамическихСписков();
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(РасходныеКассовыеОрдера);
	
	Если Не ПроверкаКонтрагентовВызовСервераПовтИсп.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "РасходныеКассовыеОрдера.Дата", Элементы.РасходныеКассовыеОрдераДата.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ЗаказыКОплате.Дата", Элементы.ЗаказыКОплатеДата.Имя);
	
	СохранитьРабочиеЗначенияПолейФормы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// МеханизмВнешнегоОборудования
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтотОбъект, "СканерШтрихкода");
	// Конец МеханизмВнешнегоОборудования

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			//Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				ОбработатьШтрихкоды(Новый Структура("Штрихкод, Количество", Параметр[0], 1)); // Достаем штрихкод из основных данных
			Иначе
				ОбработатьШтрихкоды(Новый Структура("Штрихкод, Количество", Параметр[1][1], 1)); // Достаем штрихкод из дополнительных данных
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_РасходныйКассовыйОрдер" Тогда
		ОбновитьДиначескиеСписки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	// МеханизмВнешнегоОборудования
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтотОбъект);
	// Конец МеханизмВнешнегоОборудования
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация              = Настройки.Получить("Организация");
	Касса                    = Настройки.Получить("Касса");
	Работник                 = Настройки.Получить("Работник");
	ХозяйственнаяОперация    = Настройки.Получить("ХозяйственнаяОперация");
	ДатаПлатежа              = Настройки.Получить("ДатаПлатежа");
	СписокОпераций           = Настройки.Получить("СписокОперацийОплаты");
	
	ИнициализироватьСписокОперацийОплаты();
	Если СписокОпераций <> Неопределено Тогда
		Для каждого Операция Из СписокОпераций Цикл
			Если Операция.Пометка Тогда
				ОперацияСписка = СписокОперацийОплаты.НайтиПоЗначению(Операция.Значение);
				Если ОперацияСписка <> Неопределено Тогда
					ОперацияСписка.Пометка = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	СписокОперацийОплатыПредставление = СписокОперацийОплатыПредставление(СписокОперацийОплаты);
	
	УстановитьОтборДинамическихСписков();
	
	ВыплатаРаботнику = ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыРаботнику;
	
	Элементы.ВыплатаЗарплатыРаботникОтбор.Доступность = ВыплатаРаботнику;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДиначескиеСписки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкиКОплатеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(Неопределено, Элементы.ЗаявкиКОплате.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыКОплатеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(Неопределено, Элементы.ЗаказыКОплате.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаЗарплатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(Неопределено, Элементы.ВыплатаЗарплаты.ТекущиеДанные.Ведомость);
	
КонецПроцедуры

&НаКлиенте
Процедура КассаОтборПриИзменении(Элемент)
	
	КассаОтборПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияНаОплатуДатаПлатежаОтборПриИзменении(Элемент)
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыКОплатеДатаПлатежаОтборПриИзменении(Элемент)
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаЗарплатыВыплатаПоВедомостямПриИзменении(Элемент)
	
	Работник = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	
	УстановитьПараметрыДинамическихСписков();
	
	Элементы.ВыплатаЗарплатыРаботникОтбор.Доступность = ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыРаботнику");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаЗарплатыРаботникОтборПриИзменении(Элемент)
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура СписокОперацийКОплатеОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		ОткрытьФорму("Перечисление.ХозяйственныеОперации.Форма.ФормаВыбораОперации",
			Новый Структура("СписокОпераций", СписокОперацийОплаты), Элемент);
	Иначе
		ОткрытьФорму("Перечисление.ХозяйственныеОперации.Форма.ФормаВыбораОперации",
			Новый Структура("СписокОпераций, Заголовок", СписокОперацийОплаты, НСтр("ru = 'Основания платежа'")), Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОперацийКОплатеОтборОчистка(Элемент, СтандартнаяОбработка)
	
	СписокОперацийОплаты.ЗаполнитьПометки(Ложь);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОперацийКОплатеОтборОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		
		СписокОперацийОплаты = ВыбранноеЗначение;
	Иначе
		
		Для Каждого ЭлементСписка Из СписокОперацийОплаты Цикл
			ЭлементСписка.Пометка = (ЭлементСписка.Значение = ВыбранноеЗначение);
		КонецЦикла;
	КонецЕсли;
	
	СписокОперацийОплатыПредставление = СписокОперацийОплатыПредставление(СписокОперацийОплаты);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.РасходныеКассовыеОрдера);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.РасходныеКассовыеОрдера);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура СоздатьВыдачаДенежныхСредствПодотчетнику(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратОплатыКлиенту(Команда)

	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочаяВыдачаДенежныхСредств(Команда)

	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСдачаДенежныхСредствВБанк(Команда)

	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СдачаДенежныхСредствВБанк"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнкассацию(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыдачаДенежныхСредствВДругуюКассу(Команда)

	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыдачаДенежныхСредствВКассуККМ(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ"));

КонецПроцедуры

&НаКлиенте
Процедура СоздатьОплатаДенежныхСредствВДругуюОрганизацию(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствВДругуюОрганизацию(Команда)
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВнутреннююПередачуДенежныхСредств(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонвертацияВалюты(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.КонвертацияВалюты"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыплатаЗаработнойПлатыПоВедомостям(Команда)
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыплатуЗарплатыРаздатчиком(Команда)
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыРаздатчиком"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыплатаЗаработнойПлатыРаботнику(Команда)
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыРаботнику"));
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.ЗаказыКОплате.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		
		СтруктураОснование = Новый Структура("Организация, ЗаказПоставщику, СуммаКОплате, Касса",
			СтрокаТаблицы.Организация,
			СтрокаТаблицы.Ссылка,
			СтрокаТаблицы.СуммаКОплате,
			СтрокаТаблицы.Касса);
			
		СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
		
		ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, Элементы.РасходныеКассовыеОрдера);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьЗаявку(Команда)
	
	СтрокаТаблицы = Элементы.ЗаявкиКОплате.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		
		Если ТипЗнч(СтрокаТаблицы.Ссылка) = Тип("ДокументСсылка.РаспоряжениеНаПеремещениеДенежныхСредств") Тогда
			
			СтруктураПараметры = Новый Структура("Основание", СтрокаТаблицы.Ссылка);
			
		Иначе
			СтруктураОснование = Новый Структура;
			СтруктураОснование.Вставить("НесколькоЗаявокНаРасходованиеСредств", Истина);
			СтруктураОснование.Вставить("ДокументОснование", СтрокаТаблицы.Ссылка);
			СтруктураОснование.Вставить("Сумма", СтрокаТаблицы.СуммаКОплате);
			СтруктураОснование.Вставить("БанковскийСчетКасса", СтрокаТаблицы.Касса);
			
			СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
		КонецЕсли;
		
		ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, Элементы.РасходныеКассовыеОрдера);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатитьЗарплату(Команда)
	
	СоздатьОрдерНаВыплатуЗарплаты(Элементы.ВыплатаЗарплаты.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОплатуПоКредитам(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаПоКредитам"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыдачуЗаймаКонтрагенту(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаЗаймов"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыдачуЗаймаСотруднику(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаЗаймаСотруднику"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОплатуЛизингодателю(Команда)
	
	СоздатьРасходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаЛизингодателю"));
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.РасходныеКассовыеОрдера);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.РасходныеКассовыеОрдера);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура КассаОтборПриИзмененииНаСервере()
	
	Организация = Справочники.Кассы.ПолучитьРеквизитыКассы(Касса).Организация;
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.РасходныйКассовыйОрдер.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
			Элементы.РасходныеКассовыеОрдера.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаРасходныеКассовыеОрдера;
		КонецЕсли;
		
		ПоказатьЗначение(, Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗаказыКОплатеДатаПлатежа.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗаказыКОплате.ДатаПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗаявкиКОплатеДатаПлатежа.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗаявкиКОплате.ДатаПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.СтраницаРаспоряженияНаОплату.Видимость             = ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
	Элементы.СтраницаЗаказыКОплате.Видимость                    = Не ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
	Элементы.СтраницаВыплатаЗарплаты.Видимость                  = ИспользоватьНачислениеЗарплаты И Не ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
	Элементы.КассаОтбор.Видимость                               = ИспользоватьНесколькоКасс;
	Элементы.СоздатьВыдачаДенежныхСредствВДругуюКассу.Видимость = ИспользоватьНесколькоКасс Или ИспользоватьРозничныеПродажи;
	//++ НЕ УТ
	Элементы.СоздатьОплатуЛизингодателю.Видимость               = ИспользоватьЛизинг;
	//-- НЕ УТ
	
	Элементы.СоздатьВыдачуЗаймаСотруднику.Видимость             = Ложь;
	
	//++ НЕ УТ
	Элементы.СоздатьВыдачуЗаймаСотруднику.Видимость = Не ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") И ПолучитьФункциональнуюОпцию("ИспользоватьЗаймыСотрудникам");
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаКлиенте
Процедура СоздатьРасходныйКассовыйОрдер(ХозяйственнаяОперация)

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, Элементы.РасходныеКассовыеОрдера);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерНаВыплатуЗарплаты(СтрокаТаблицы)
	
	Если СтрокаТаблицы <> Неопределено Тогда
		
		Если СтрокаТаблицы.Свойство("Касса") Тогда
			Если ЗначениеЗаполнено(СтрокаТаблицы.Касса) Тогда
				ОснованиеКасса = СтрокаТаблицы.Касса;
			Иначе
				ОснованиеКасса = Касса;
			КонецЕсли;
		Иначе
			ОснованиеКасса = Неопределено;
		КонецЕсли;
		
		Если СтрокаТаблицы.Свойство("Организация") Тогда
			Если ЗначениеЗаполнено(СтрокаТаблицы.Организация) Тогда
				ОснованиеОрганизация = СтрокаТаблицы.Организация;
			Иначе
				ОснованиеОрганизация = Неопределено;
			КонецЕсли;
		Иначе
			ОснованиеОрганизация = Неопределено;
		КонецЕсли;
		
		СтруктураОснование = Новый Структура;
		СтруктураОснование.Вставить("Касса", ОснованиеКасса);
		СтруктураОснование.Вставить("Организация", ОснованиеОрганизация);
		СтруктураОснование.Вставить("Работник", Работник);
		СтруктураОснование.Вставить("Ведомость", СтрокаТаблицы.Ведомость);
		СтруктураОснование.Вставить("Заявка", СтрокаТаблицы.Заявка);
		СтруктураОснование.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
		
		//++ НЕ УТ
		
		Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу")
			И ТипЗнч(СтрокаТаблицы.Ведомость) = Тип("ДокументСсылка.ВедомостьНаВыплатуЗарплатыРаздатчиком") Тогда
			СтруктураОснование.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыРаздатчиком"));
		КонецЕсли;
		
		//-- НЕ УТ
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
		ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, Элементы.РасходныеКассовыеОрдера);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ИнициализироватьСписокОперацийОплаты()
	
	СписокОпераций = Новый СписокЗначений;
	
	Если ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		
		Операции = Перечисления.ХозяйственныеОперации;
		
		СписокОпераций.Добавить(Операции.ОплатаПоставщику);
		СписокОпераций.Добавить(Операции.ВозвратОплатыКлиенту);
		СписокОпераций.Добавить(Операции.ВыдачаДенежныхСредствПодотчетнику, НСтр("ru = 'Выдача подотчетнику'"));
		СписокОпераций.Добавить(Операции.ПеречислениеТаможне, НСтр("ru = 'Таможенный платеж'"));
		СписокОпераций.Добавить(Операции.КонвертацияВалюты);
		СписокОпераций.Добавить(Операции.ОплатаДенежныхСредствВДругуюОрганизацию, НСтр("ru = 'Оплата в другую организацию'"));
		СписокОпераций.Добавить(Операции.ВозвратДенежныхСредствВДругуюОрганизацию, НСтр("ru = 'Возврат в другую организацию'"));
		СписокОпераций.Добавить(Операции.ВнутренняяПередачаДенежныхСредств, НСтр("ru = 'Внутренняя передача'"));
		СписокОпераций.Добавить(Операции.ВыплатаЗарплаты);
		СписокОпераций.Добавить(Операции.ПрочиеРасходы);
		СписокОпераций.Добавить(Операции.ПрочаяВыдачаДенежныхСредств, НСтр("ru = 'Прочая выдача'"));
		СписокОпераций.Добавить(Операции.ОплатаПоКредитам);
		СписокОпераций.Добавить(Операции.ПеречислениеНаДепозиты);
		СписокОпераций.Добавить(Операции.ВыдачаЗаймов);
	Иначе
	
		СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.РасчетыСПоставщиками);
		СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.ВозвратыКлиентам);
		СписокОпераций.Добавить(Перечисления.ОбластиПланированияПлатежей.ДенежныеСредстваВПути);
		
	КонецЕсли;
	
	Для каждого Операция Из СписокОперацийОплаты Цикл
		Если Операция.Пометка Тогда
			ОперацияСписка = СписокОпераций.НайтиПоЗначению(Операция.Значение);
			Если ОперацияСписка <> Неопределено Тогда
				ОперацияСписка.Пометка = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СписокОперацийОплаты = СписокОпераций;
	
	Элементы.СписокОперацийКОплатеОтбор.СписокВыбора.Очистить();
	Для каждого Операция Из СписокОперацийОплаты Цикл
		Элементы.СписокОперацийКОплатеОтбор.СписокВыбора.Добавить(Операция.Значение, Операция.Представление);
	КонецЦикла;
	Элементы.ЗаказыСписокОперацийКОплатеОтбор.СписокВыбора.Очистить();
	Для каждого Операция Из СписокОперацийОплаты Цикл
		Элементы.ЗаказыСписокОперацийКОплатеОтбор.СписокВыбора.Добавить(Операция.Значение, Операция.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРабочиеЗначенияПолейФормы(СохранитьНеопределено = Ложь)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяОрганизация", "", ?(СохранитьНеопределено, Неопределено, Организация));
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяКасса", "", ?(СохранитьНеопределено, Неопределено, Касса));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	СписокКасс = Новый СписокЗначений;
	СписокКасс.Добавить(Касса);
	СписокКасс.Добавить(Справочники.Кассы.ПустаяСсылка());
	
	Для Каждого ДинамическийСписок Из МассивДинамическихСписков() Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, "Организация", СписокОрганизаций, ВидСравненияКомпоновкиДанных.ВСписке,, ЗначениеЗаполнено(Организация));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, "Касса", СписокКасс, ВидСравненияКомпоновкиДанных.ВСписке,, ЗначениеЗаполнено(Касса));
	КонецЦикла;
	
	СохранитьРабочиеЗначенияПолейФормы();
	
	Если ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		
		ВыбранныеОперации = Новый Массив;
		Для Каждого ЭлементСписка Из СписокОперацийОплаты Цикл
			Если ЭлементСписка.Пометка Тогда
				ВыбранныеОперации.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ЗаявкиКОплате,
			"ХозяйственнаяОперация",
			ВыбранныеОперации,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ВыбранныеОперации.Количество());
	Иначе
		
		
		ОбластиПланирования = Новый Массив;
		Для каждого ЭлементСписка Из СписокОперацийОплаты Цикл
			Если ЭлементСписка.Пометка Тогда
				ОбластиПланирования.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ЗаказыКОплате,
			"ОбластьПланирования",
			ОбластиПланирования,
			ВидСравненияКомпоновкиДанных.ВСписке,,
			ОбластиПланирования.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	Граница = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Дата('39990101'));
	ЗаявкиКОплате.Параметры.УстановитьЗначениеПараметра("ДатаПлатежа", Граница);
	ЗаказыКОплате.Параметры.УстановитьЗначениеПараметра("ДатаПлатежа", Граница);
	
	Если Константы.ИспользоватьНачислениеЗарплаты.Получить() Тогда
		ВыплатаЗарплаты.Параметры.УстановитьЗначениеПараметра("Работник", Работник);
		ВыплатаЗарплаты.Параметры.УстановитьЗначениеПараметра(
			"ВыплатаПоВедомости",
			ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДиначескиеСписки()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРаспоряженияНаОплату Тогда
		Элементы.ЗаявкиКОплате.Обновить();
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаказыКОплате Тогда
		Элементы.ЗаказыКОплате.Обновить();
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВыплатаЗарплаты Тогда
		Элементы.ВыплатаЗарплаты.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция МассивДинамическихСписков()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(РасходныеКассовыеОрдера);
	МассивСписков.Добавить(ЗаявкиКОплате);
	МассивСписков.Добавить(ЗаказыКОплате);
	МассивСписков.Добавить(ВыплатаЗарплаты);
	
	Возврат МассивСписков;

КонецФункции

//++ НЕ УТ
&НаСервере
Функция ТекстЗапросаВыплатаЗарплаты()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Зарплата.Ссылка КАК Ведомость,
	|	Зарплата.Ссылка.Организация КАК Организация,
	|	Зарплата.Ссылка.Подразделение КАК Подразделение,
	|	Зарплата.Ссылка.Касса КАК Касса,
	|	СУММА(Зарплата.КВыплате) КАК Сумма,
	|	ЗНАЧЕНИЕ(Документ.ЗаявкаНаРасходованиеДенежныхСредств.ПустаяСсылка) КАК Заявка
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу.Зарплата КАК Зарплата
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОплатаВедомостейНаВыплатуЗарплаты КАК ОплатаВедомостей
	|		ПО Зарплата.Ссылка = ОплатаВедомостей.Ведомость
	|			И Зарплата.Сотрудник.ФизическоеЛицо = ОплатаВедомостей.ФизическоеЛицо
	|ГДЕ
	|	ОплатаВедомостей.Ведомость ЕСТЬ NULL 
	|	И Зарплата.Ссылка.Проведен
	|	И (Зарплата.Сотрудник.ФизическоеЛицо = &Работник
	|			ИЛИ &ВыплатаПоВедомости)
	|
	|СГРУППИРОВАТЬ ПО
	|	Зарплата.Ссылка,
	|	Зарплата.Ссылка.Организация,
	|	Зарплата.Ссылка.Подразделение,
	|	Зарплата.Ссылка.Касса
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Зарплата.Ссылка,
	|	Зарплата.Ссылка.Организация,
	|	Зарплата.Ссылка.Подразделение,
	|	Неопределено,
	|	СУММА(Зарплата.КВыплате),
	|	ЗНАЧЕНИЕ(Документ.ЗаявкаНаРасходованиеДенежныхСредств.ПустаяСсылка)
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыРаздатчиком.Зарплата КАК Зарплата
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОплатаВедомостейНаВыплатуЗарплаты КАК ОплатаВедомостей
	|		ПО Зарплата.Ссылка = ОплатаВедомостей.Ведомость
	|			И Зарплата.Сотрудник.ФизическоеЛицо = ОплатаВедомостей.ФизическоеЛицо
	|ГДЕ
	|	ОплатаВедомостей.Ведомость ЕСТЬ NULL 
	|	И Зарплата.Ссылка.Проведен
	|	И (Зарплата.Сотрудник.ФизическоеЛицо = &Работник
	|			ИЛИ &ВыплатаПоВедомости)
	|
	|СГРУППИРОВАТЬ ПО
	|	Зарплата.Ссылка,
	|	Зарплата.Ссылка.Организация,
	|	Зарплата.Ссылка.Подразделение";
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ

&НаКлиентеНаСервереБезКонтекста
Функция СписокОперацийОплатыПредставление(СписокОпераций)
	
	СписокОперацийОплатыПредставление = "";
	Для Каждого ЭлементСписка Из СписокОпераций Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокОперацийОплатыПредставление = СписокОперацийОплатыПредставление
				+ ?(ЗначениеЗаполнено(СписокОперацийОплатыПредставление), ", ", "")
				+ ?(ЗначениеЗаполнено(ЭлементСписка.Представление), ЭлементСписка.Представление, ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокОперацийОплатыПредставление;
	
КонецФункции

#КонецОбласти

#КонецОбласти
