﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Список.ТекстЗапроса = Документы.ТТНВходящаяЕГАИС.ТекстЗапросаТТН();
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("СкладТТН", СкладТТН);
		СтруктураБыстрогоОтбора.Свойство("СтатусОбработки", СтатусОбработки);
		СтруктураБыстрогоОтбора.Свойство("СостояниеНакладной", СостояниеНакладной);
	КонецЕсли;
	
	ЗаполнитьСпискокВыбораПоСостояниюНакладной();
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Организация", Организация, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ТорговыйОбъект", СкладТТН, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "СтатусОбработки", 
																		СтатусОбработки,
																		СтруктураБыстрогоОтбора,
																		ЗначениеЗаполнено(СтатусОбработки),
																		,
																		Истина);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "СостояниеНакладной", 
																		?(ЗначениеЗаполнено(СостояниеНакладной), Число(СостояниеНакладной), СостояниеНакладной), 
																		СтруктураБыстрогоОтбора,
																		ЗначениеЗаполнено(СостояниеНакладной),
																		,
																		Истина);
	
	Элементы.СкладТТН.Видимость           = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	Элементы.ОрганизацияТТН.Видимость     = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.СостояниеНакладной.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам");
	
	ВыполнениеСинхронизацииСЕГАИС = РольДоступна("ДобавлениеИзменениеВходящихТТНЕГАИС")
		ИЛИ Пользователи.ЭтоПолноправныйПользователь();
	Элементы.СписокВыполнитьОбмен.Видимость        = ВыполнениеСинхронизацииСЕГАИС;
	Элементы.СписокПодтвердитьПолучение.Видимость  = ВыполнениеСинхронизацииСЕГАИС;
	Элементы.СписокОтказатьсяОтНакладной.Видимость = ВыполнениеСинхронизацииСЕГАИС;
	
	// МенюОтчеты
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьПодменюОтчеты(ЭтотОбъект);
	// Конец МенюОтчеты
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
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
	
	Если ИмяСобытия = "Запись_ПоступлениеТоваровУслуг"
		ИЛИ ИмяСобытия = "ИзменениеСостоянияЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("СкладТТН", СкладТТН);
		Настройки.Удалить("СкладТТН");
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		Настройки.Удалить("Организация");
		СтруктураБыстрогоОтбора.Свойство("СтатусОбработки", СтатусОбработки);
		Настройки.Удалить("СтатусОбработки");
		СтруктураБыстрогоОтбора.Свойство("СостояниеНакладной", СостояниеНакладной);
		Настройки.Удалить("СостояниеНакладной");
	Иначе
		СкладТТН = Настройки.Получить("СкладТТН");
		Организация = Настройки.Получить("Организация");
		СтатусОбработки = Настройки.Получить("СтатусОбработки");
		СостояниеНакладной = Настройки.Получить("СостояниеНакладной");
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Организация", Организация, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "ТорговыйОбъект", СкладТТН, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
																		"СтатусОбработки",
																		СтатусОбработки,
																		СтруктураБыстрогоОтбора,
																		Настройки,
																		ЗначениеЗаполнено(СтатусОбработки),
																		,
																		Ложь);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
																		"СостояниеНакладной",
																		?(ЗначениеЗаполнено(СостояниеНакладной), Число(СостояниеНакладной), СостояниеНакладной), 
																		СтруктураБыстрогоОтбора, 
																		Настройки,
																		ЗначениеЗаполнено(СостояниеНакладной),
																		,
																		Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ТорговыйОбъект",
		СкладТТН,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(СкладТТН));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"СтатусОбработки",
		СтатусОбработки,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(СтатусОбработки));
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеНакладнойПриИзменении(Элемент)
	
	Состояние = ?(ЗначениеЗаполнено(СостояниеНакладной), Число(СостояниеНакладной), 0);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"СостояниеНакладной",
		Состояние,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Состояние));

КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЖурналЗакупкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ОткрытьЖурнал(ПараметрыЖурнала());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьПоступлениеПоТТНЕГАИС(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено
		И ТекущаяСтрока.ПоступлениеТоваровПредставление = "" 
		И ТекущаяСтрока.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа")
		И ТекущаяСтрока.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяАктОтказа") Тогда
		
		СоздатьПоступлениеНаОснованииТТН(ТекущаяСтрока.Ссылка);
		
	КонецЕсли;
	
	Если ТекущаяСтрока <> Неопределено
		И (ТекущаяСтрока.СтатусОбработки = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа")
			ИЛИ ТекущаяСтрока.СтатусОбработки = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяАктОтказа")) Тогда
		
		ПоказатьПредупреждениеПоступлениеНеТребуется();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязатьПоступлениеТоваровИУслуг(Команда)
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено
		И ТекущаяСтрока.ПоступлениеТоваровПредставление = ""
		И ТекущаяСтрока.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа")
		И ТекущаяСтрока.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяАктОтказа") Тогда
		
		СвязатьСПоступлениемТТН(ТекущаяСтрока.Ссылка);
		
	КонецЕсли;
	
	Если ТекущаяСтрока <> Неопределено
		И (ТекущаяСтрока.СтатусОбработки = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа")
			ИЛИ ТекущаяСтрока.СтатусОбработки = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяАктОтказа")) Тогда
		
		ПоказатьПредупреждениеПоступлениеНеТребуется();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьКлассификаторыЕГАИС(Команда)
	
	ТоварноТранспортныеНакладные = Новый Массив;
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		Если ДанныеСтроки <> Неопределено Тогда
			ТоварноТранспортныеНакладные.Добавить(ДанныеСтроки.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	ОчиститьСообщения();
	
	ВыполнитьСопоставлениеСправочников(ТоварноТранспортныеНакладные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПолучение(Команда)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТоварноТранспортнаяНакладнаяЕГАИС = ТекущиеДанные.Ссылка;
	
	Если ТекущиеДанные.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПринятИзЕГАИС")
		И ТекущиеДанные.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаОтказа")
		И ТекущиеДанные.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаПодтверждения")
		И ТекущиеДанные.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаРасхождений") Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТоварноТранспортнаяНакладнаяЕГАИС", ТоварноТранспортнаяНакладнаяЕГАИС);
	
	ИнтеграцияЕГАИСКлиент.ПередатьОтветЕГАИС(
		ТоварноТранспортнаяНакладнаяЕГАИС,
		Новый ОписаниеОповещения("ОперацияЕГАИСЗавершение", ЭтотОбъект, ДополнительныеПараметры));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтказатьсяОтНакладной(Команда)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'"));
		Возврат;
	КонецЕсли;
	
	ТоварноТранспортнаяНакладнаяЕГАИС = ТекущиеДанные.Ссылка;
	
	Если ТекущиеДанные.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПринятИзЕГАИС")
		И ТекущиеДанные.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаОтказа")
		И ТекущиеДанные.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаПодтверждения")
		И ТекущиеДанные.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаРасхождений") Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТоварноТранспортнаяНакладнаяЕГАИС", ТоварноТранспортнаяНакладнаяЕГАИС);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПослеПередачиДанныхЕГАИС", ИнтеграцияЕГАИСКлиент);
	ИнтеграцияЕГАИСКлиент.ОтказатьсяОтДанныхЕГАИС(
		Элементы.Список.ТекущиеДанные.Ссылка,
		ОповещениеПриЗавершении);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияЕГАИСКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТоварноТранспортныеНакладные

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.СписокПоступлениеТоваров Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.ПоступлениеТоваров) Тогда
			ПоказатьЗначение(,ТекущаяСтрока.ПоступлениеТоваров);
		ИначеЕсли ТекущаяСтрока.СтатусОбработки <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа") Тогда
			
			СписокКнопок = Новый СписокЗначений;
			СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Оформить новое поступление'"), Ложь);
			СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Связать с имеющимся поступлением'"), Ложь);
			СписокКнопок.Добавить(КодВозвратаДиалога.Отмена,"Отмена", Ложь);
			
			ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьСвязатьПоступлениеТоваровИУслугПослеВыбораВопрос",
					ЭтотОбъект,
					Новый Структура("ТТНСсылка", ТекущаяСтрока.Ссылка)),
					НСтр("ru='Оформить новое поступление товаров или связать с уже имеющимся ?'"), 
					СписокКнопок);
		ИначеЕсли ТекущаяСтрока.СтатусОбработки = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа") Тогда
			ПоказатьПредупреждениеПоступлениеНеТребуется();
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСвязатьПоступлениеТоваровИУслугПослеВыбораВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		СоздатьПоступлениеНаОснованииТТН(ДополнительныеПараметры.ТТНСсылка);
		
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		
		СвязатьСПоступлениемТТН(ДополнительныеПараметры.ТТНСсылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПоступлениеТоваров.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПоступлениеТоваров");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтатусОбработки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<требуется оформить>'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПоступлениеТоваров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПоступлениеТоваров");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтатусОбработки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиТТНВходящейЕГАИС.ПереданАктОтказа");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПоступлениеТоваров.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПоступлениеТоваров");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет);
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПоступлениеТоваровУслуг.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказПоставщику.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЕГАИС

&НаКлиенте
Процедура ОперацияЕГАИСЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставлениеКлассификаторовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Свойство("СоздатьПоступление") Тогда
		СоздатьПоступлениеНаОснованииТТН(ДополнительныеПараметры.ТТНСсылка, Ложь);
	ИначеЕсли ДополнительныеПараметры.Свойство("ВыбратьПоступление") Тогда
		СвязатьСПоступлениемТТН(ДополнительныеПараметры.ТТНСсылка, Ложь);
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСпискокВыбораПоСостояниюНакладной()
	
	СписокВыбора = Элементы.СостояниеНакладной.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить("1", НСтр("ru='Требуется оформить'"));
	СписокВыбора.Добавить("2", НСтр("ru='Оформлено'"));
	
КонецФункции

&НаСервере
Процедура ОбработкаВыбораПоступлениеТоваров(ТТНСсылка, ВыбранноеЗначение)

	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		НачатьТранзакцию();
		Попытка
		
			ПоступлениеОбъект = ВыбранноеЗначение.ПолучитьОбъект();
			Если ПоступлениеОбъект = Неопределено Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли; 
			
			ПоступлениеОбъект.ТоварноТранспортнаяНакладнаяЕГАИС = ТТНСсылка;
			ПоступлениеОбъект.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеНаОснованииТТН(ТТНСсылка, СопоставлятьКлассификаторы = Истина)
	
	Если РозничныеПродажиВызовСервера.ТТНПолностьюСопоставлена(ТТНСсылка) Тогда
		
		ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокумента", Новый Структура("Основание", ТТНСсылка));
		
	Иначе
		
		Если Не СопоставлятьКлассификаторы Тогда
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Сопоставить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"СопоставитьСтрокиВопросЗавершение",
				ЭтотОбъект,
				Новый Структура("СоздатьПоступление, ТТНСсылка",Истина, ТТНСсылка)),
			НСтр("ru='В документе найдены несопоставленные элементы классификаторов ЕГАИС.
			          |Сопоставить классификаторы?'"),
			Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязатьСПоступлениемТТН(ТТНСсылка, СопоставлятьКлассификаторы = Истина)
	
	СтруктураОтбор = Новый Структура;
	СтруктураОтбор.Вставить("Организация");
	СтруктураОтбор.Вставить("Склад");
	СтруктураОтбор.Вставить("ЕстьАлкогольнаяПродукция", Истина);
	СтруктураОтбор.Вставить("ТолькоБезТТН_ЕГАИС", Истина);
	СтруктураОтбор.Вставить("Контрагент");
	
	Если РозничныеПродажиВызовСервера.ТТНПолностьюСопоставлена(ТТНСсылка, СтруктураОтбор) Тогда
		
		Если НЕ ЗначениеЗаполнено(СтруктураОтбор.Контрагент) Тогда
			СтруктураОтбор.Удалить("Контрагент");
		КонецЕсли;
		
		ОткрытьФорму(
			"Документ.ПоступлениеТоваровУслуг.ФормаВыбора",
			Новый Структура("Отбор", СтруктураОтбор),
			ЭтаФорма,
			,,, Новый ОписаниеОповещения("СвязатьПоступлениеТоваровИУслугПослеВыбора", ЭтотОбъект, Новый Структура("ТТНСсылка", ТТНСсылка)));
			
	Иначе
		
		Если Не СопоставлятьКлассификаторы Тогда
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Сопоставить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"СопоставитьСтрокиВопросЗавершение",
				ЭтотОбъект,Новый Структура("ВыбратьПоступление, ТТНСсылка", Истина, ТТНСсылка)),
			НСтр("ru='В документе найдены несопоставленные элементы классификаторов ЕГАИС.
			          |Сопоставить классификаторы?'"),
			Кнопки);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьСтрокиВопросЗавершение(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(ДопПараметры.ТТНСсылка);
		ВыполнитьСопоставлениеСправочников(МассивСсылок, ДопПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСопоставлениеСправочников(МассивСсылок, ДопПараметры = Неопределено)
	
	ПараметрыСопоставления = Новый Структура;
	
	Если ЗначениеЗаполнено(ДопПараметры) И ДопПараметры.Свойство("СоздатьПоступление") Тогда
		ПараметрыСопоставления.Вставить("СоздатьПоступление", ДопПараметры.СоздатьПоступление);
		ПараметрыСопоставления.Вставить("ТТНСсылка", ДопПараметры.ТТНСсылка);
	ИначеЕсли ЗначениеЗаполнено(ДопПараметры) И ДопПараметры.Свойство("ВыбратьПоступление") Тогда
		ПараметрыСопоставления.Вставить("ВыбратьПоступление", ДопПараметры.ВыбратьПоступление);
		ПараметрыСопоставления.Вставить("ТТНСсылка", ДопПараметры.ТТНСсылка);
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ТоварноТранспортныеНакладные", МассивСсылок);
	ОткрытьФорму(
		"Обработка.СопоставлениеКлассификаторовЕГАИС.Форма.СопоставлениеАлкогольнойПродукцииЕГАИСНоменклатурой",
		ПараметрыОткрытияФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("СопоставлениеКлассификаторовЗавершение", ЭтотОбъект, ПараметрыСопоставления));
	
КонецПроцедуры

&НаКлиенте
Процедура СвязатьПоступлениеТоваровИУслугПослеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если РозничныеПродажиВызовСервера.ЕстьРасхожденияТоваровТТН_ЕГАИСПоступления(ДополнительныеПараметры.ТТНСсылка, Результат) Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("СвязатьПоступлениеТоваровИУслугПослеВыбораВопрос",
					ЭтотОбъект,
					Новый Структура("ТТНСсылка, Результат", ДополнительныеПараметры.ТТНСсылка, Результат)),
				НСтр("ru='В товарах выбранного поступления есть алкогольная продукция, которой нет в ТТН. Продолжить выбор?'"), 
				РежимДиалогаВопрос.ДаНет);
		Иначе
			ОбработкаВыбораПоступлениеТоваров(ДополнительныеПараметры.ТТНСсылка, Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязатьПоступлениеТоваровИУслугПослеВыбораВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ОбработкаВыбораПоступлениеТоваров(ДополнительныеПараметры.ТТНСсылка, ДополнительныеПараметры.Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениеПоступлениеНеТребуется()
	
	ПоказатьПредупреждение( , НСтр("ru='Поступление товаров для данной ТТН ЕГАИС не требуется.'"));
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Функция ПараметрыЖурнала()
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Организация",Организация);
	СтруктураБыстрогоОтбора.Вставить("Склад",СкладТТН);
	
	ПараметрыЖурнала = Новый Структура;
	ПараметрыЖурнала.Вставить("СтруктураБыстрогоОтбора",СтруктураБыстрогоОтбора);
	ПараметрыЖурнала.Вставить("ИмяРабочегоМеста","ЖурналДокументовЗакупки");
	ПараметрыЖурнала.Вставить("КлючНазначенияФормы","Накладные");
	ПараметрыЖурнала.Вставить("СинонимЖурнала",НСтр("ru = 'Документы закупки'"));
	
	Возврат ПараметрыЖурнала;
	
КонецФункции

#КонецОбласти

#КонецОбласти
