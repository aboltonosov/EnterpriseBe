﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"ПредставлениеОбособленногоПодразделения",
		НСтр("ru='Обособленное подразделение'"));

	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		
		ТолькоПросмотр = Истина;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", Справочники.Партнеры.НеизвестныйПартнер, ВидСравненияКомпоновкиДанных.НеРавно);
		
	КонецЕсли;
		
	Если Параметры.Свойство("Отбор")
		И Параметры.Отбор.Свойство("Партнер")
		И ЗначениеЗаполнено(Параметры.Отбор.Партнер) Тогда
		
		КлючНастроек = "ФормаСпискаПараметрическая" + Параметры.Отбор.Партнер.УникальныйИдентификатор();
		ЗагрузитьНастройки();
		
		Партнер = Параметры.Отбор.Партнер;
		
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Партнер, СписокПартнеров);
		
		Элементы.ПоказыватьГрупповые.Видимость = СписокПартнеров.Количество() > 1 И ПоПартнеру;
		
		Если ЗначениеЗаполнено(Партнер) Тогда
			НайденныйПартнер = СписокПартнеров.НайтиПоЗначению(Партнер);
			
			Если НайденныйПартнер <> Неопределено Тогда
				Если Параметры.Свойство("ЗаголовокПоПартнеру") И НЕ ПустаяСтрока(Параметры.ЗаголовокПоПартнеру) Тогда
					ПрефиксЗаголовкаПоПартнеру = Параметры.ЗаголовокПоПартнеру;
				Иначе
					ПрефиксЗаголовкаПоПартнеру = НСтр("ru='По партнеру'");
				КонецЕсли;
				ТекстЗаголовка = НСтр("ru='%1 ""%2""'");
				ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, ПрефиксЗаголовкаПоПартнеру, НайденныйПартнер.Представление); 
			КонецЕсли;
			
		КонецЕсли;
		
		Элементы.ПоПартнеру.Заголовок = ТекстЗаголовка;
		
		Параметры.Отбор.Удалить("Партнер");
		
		Если ПоПартнеру Тогда
			УстановитьОтборПартнеровСервер(ПоказыватьГрупповые И Элементы.ПоказыватьГрупповые.Видимость);
		КонецЕсли;
		
	Иначе
		Партнер = Справочники.Партнеры.ПустаяСсылка();
		Элементы.ПоказыватьГрупповые.Видимость = Ложь;
		Элементы.ПоПартнеру.Видимость          = Ложь;
	КонецЕсли; 
	
	ИспользоватьПроверкуКонтрагентов                  = ПроверкаКонтрагентов.ПроверкаКонтрагентовВключена();
	Элементы.ЕстьОшибкиПроверкаКонтрагентов.Видимость = ИспользоватьПроверкуКонтрагентов;
	Элементы.ГруппаЛегенда.Видимость                  = ИспользоватьПроверкуКонтрагентов;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоПартнеруПриИзменении(Элемент)

	ПоказыватьГрупповые = ПоПартнеру;
	Элементы.ПоказыватьГрупповые.Видимость = (СписокПартнеров.Количество() > 1 И ПоПартнеру);
	Если ПоПартнеру Тогда
		УстановитьОтборПартнеров(ПоПартнеру);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Партнер");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьГрупповыеПриИзменении(Элемент)

	УстановитьОтборПартнеров(ПоказыватьГрупповые); 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если (Не Партнер.Пустая()) И (НЕ Копирование) Тогда
		
		Отказ = Истина;
		Основание = Новый Структура("Партнер",Партнер);
		СтруктураПараметров = Новый Структура("Основание", Основание);
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", СтруктураПараметров,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборПартнеров(УстановитьДляГруппы = Истина)
	
	ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список).Элементы.Очистить();
	
	Если УстановитьДляГруппы Тогда
		//создать элемент группы - отбор по партнеру
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", СписокПартнеров, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", Партнер, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПартнеровСервер(УстановитьДляГруппы = Истина)
	
	ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список).Элементы.Очистить();
	
	Если УстановитьДляГруппы Тогда
		//создать элемент группы - отбор по партнеру
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", СписокПартнеров, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", Партнер, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	Перем Настройки;
	
	Настройки = Новый Соответствие;
	Настройки.Вставить("ПоказыватьГрупповые", ПоказыватьГрупповые);
	Настройки.Вставить("ПоПартнеру", ПоПартнеру);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Справочники.Контрагенты", КлючНастроек, Настройки);

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройки()
	
	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Справочники.Контрагенты", КлючНастроек);
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда
		ПоказыватьГрупповые = ЗначениеНастроек.Получить("ПоказыватьГрупповые");
		ПоПартнеру          = ЗначениеНастроек.Получить("ПоПартнеру");
	Иначе
		ПоПартнеру          = Истина;
		ПоказыватьГрупповые = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти