﻿&НаКлиенте
Перем ОткрытыеФормы Экспорт;


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.ВерсионированиеОбъектов
		ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
		// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
		
		// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
		ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
		// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
		
		// СтандартныеПодсистемы.Печать
		УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
		// Конец СтандартныеПодсистемы.Печать
		
		// СтандартныеПодсистемы.Свойства
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Объект", Сотрудник);
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
		УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, ФизическоеЛицо.ФИО, "ФизическоеЛицо");	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

	СотрудникиФормы.СотрудникиПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьОтображениеГруппВСотрудников();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПослеОткрытияФормы", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	Если Модифицированность Тогда
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ТекстПредупреждения);
	Иначе
		СотрудникиКлиент.ПроверитьНеобходимостьЗаписи(ЭтаФорма, Отказ);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	СотрудникиКлиент.СотрудникиПриЗакрытии(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.Свойства
		Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененЗаголовокФормыСотрудника" Тогда
		
		// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
		СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления(ЭтотОбъект);
		// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

	КонецЕсли;
		
	СотрудникиКлиент.СотрудникиОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.Свойства
		УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	СотрудникиФормы.СотрудникиПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаГрупп = ГруппыСотрудников.ГруппыСотрудников(СотрудникСсылка, Ложь);
	СписокГруппСотрудников.ЗагрузитьЗначения(ТаблицаГрупп.ВыгрузитьКолонку("Группа"));
	УстановитьПривилегированныйРежим(Ложь);
	
	УстановитьОтображениеГруппВСотрудников();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если НЕ Отказ И НЕ ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда 
		ЗаписатьНаКлиенте(Ложь, , Отказ);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.Свойства
		УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.Контактная информация
	Если КонтактнаяИнформацияФизическогоЛица <> Неопределено Тогда
		УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(КонтактнаяИнформацияФизическогоЛица, ФизическоеЛицо);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Контактная информация
	
	СотрудникиФормы.СотрудникиПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	СотрудникиФормы.СотрудникиПриЗаписиНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	СписокГруппСотрудников.ЗаполнитьПометки(Ложь);
	ТаблицаГрупп = ГруппыСотрудников.ГруппыСотрудников(СотрудникСсылка, Ложь);
	Для каждого СтрокаТаблицы Из ТаблицаГрупп Цикл
		
		ЭлементСписка = СписокГруппСотрудников.НайтиПоЗначению(СтрокаТаблицы.Группа);
		Если ЭлементСписка = Неопределено Тогда
			
			НаборЗаписей = РегистрыСведений.СоставГруппСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Сотрудник.Установить(СтрокаТаблицы.Сотрудник);
			НаборЗаписей.Отбор.ГруппаСотрудников.Установить(СтрокаТаблицы.Группа);
			
			НаборЗаписей.Записать();
			
		Иначе
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого ЭлементСписка Из СписокГруппСотрудников Цикл
		
		Если Не ЭлементСписка.Пометка Тогда
			
			НаборЗаписей = РегистрыСведений.СоставГруппСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Сотрудник.Установить(СотрудникСсылка);
			НаборЗаписей.Отбор.ГруппаСотрудников.Установить(ЭлементСписка.Значение);
			
			Запись = НаборЗаписей.Добавить();
			Запись.Сотрудник = СотрудникСсылка;
			Запись.ГруппаСотрудников = ЭлементСписка.Значение;
			
			НаборЗаписей.Записать();
			
		КонецЕсли; 
		
	КонецЦикла;
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриЗаписиНаСервере(ЭтотОбъект, ФизическоеЛицо.ФИО, ФизическоеЛицо.Ссылка, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = Перечисления.ПолФизическогоЛица.Мужской, 1, 2), Неопределено));	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	СотрудникиФормы.СотрудникиПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	СотрудникиКлиент.СотрудникиПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.Свойства
		УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты, Сотрудник);
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	СотрудникиФормы.СотрудникиОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СписокГруппСотрудниковДекорацияНажатие(Элемент)
	
	ВыбратьГруппыСотрудников();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокГруппСотрудниковНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьГруппыСотрудников();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеФормыНажатие(Элемент, СтандартнаяОбработка = Ложь)

	СотрудникиКлиентРасширенный.ОбработатьСобытиеДополнительногоПоляФормыНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"

&НаКлиенте
Процедура Подключаемый_ПояснениеНажатие(Элемент, СтандартнаяОбработка = Ложь)

	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВ"

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()

	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Сотрудник.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Сотрудник"));

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с другими сотрудниками.

&НаКлиенте
Процедура Подключаемый_ОткрытьФормуСотрудника(Команда)

	СотрудникиКлиент.ОткрытьФормуСотрудника(ЭтаФорма, Команда);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДругиеМестаРаботы(Команда)

	СотрудникиКлиент.ОткрытьФормуСпискаМестРаботыФизическогоЛица(ФизическоеЛицоСсылка, ЭтаФорма);

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Сотрудник);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ОформитьПриемНаРаботу(Команда)

	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, СотрудникСсылка, "Документы.ПриемНаРаботу");

КонецПроцедуры

&НаКлиенте
Процедура ОформитьДоговорРаботыУслуги(Команда)

	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, СотрудникСсылка, "Документы.ДоговорРаботыУслуги");

КонецПроцедуры

&НаКлиенте
Процедура ОформитьДоговорАвторскогоЗаказа(Команда)

	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, СотрудникСсылка, "Документы.ДоговорАвторскогоЗаказа");

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОформитьНаОсновании(Команда)
	
	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, СотрудникСсылка, Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда) Экспорт
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьНаКлиенте(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Склонения(Команда)
	
	СклонениеПредставленийОбъектовКлиент.ОбработатьКомандуСклонения(ЭтотОбъект, ФизическоеЛицо.ФИО, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"), 1, 2), Неопределено));
	    			
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Функция ПравилоФормированияПредставления() Экспорт
	Возврат ПараметрыСеанса.ПравилоФормированияПредставленияЭлементовСправочникаСотрудники;
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеСвязанныеСФизлицом() Экспорт

	СотрудникиФормы.ПрочитатьДанныеСвязанныеССотрудником(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДополнитьПредставлениеПриИзменении(Элемент)

	СотрудникиКлиент.ДополнитьПредставлениеСотрудникаПриИзменении(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ОбработкаИзмененияДанныхОРабочемМестеНаСервере(ПараметрСотрудник) Экспорт

	СотрудникиФормы.ОбработкаИзмененияДанныхОРабочемМесте(ЭтаФорма, ПараметрСотрудник, "ДругиеРабочиеМеста");

КонецПроцедуры

&НаСервере
Процедура ТекущаяОрганизацияПриИзмененииНаСервере() Экспорт

	СотрудникиФормы.ПриИзмененииОрганизации(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФизическогоЛицаНаСервере() Экспорт

	СотрудникиФормы.ОбновитьДанныеФизическогоЛица(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияФормы()
	
	СотрудникиКлиент.СотрудникиПриОткрытии(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеПодработкиНажатие(Элемент, СтандартнаяОбработка)
	ПоказатьЗначение(, НазначениеПодработки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// При изменении данных физлица / сотрудника.

&НаКлиенте
Процедура ТекущаяОрганизацияПриИзменении(Элемент)

	ТекущаяОрганизацияПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ФизлицоИННПриИзменении(Элемент)

	СотрудникиКлиент.СотрудникиИННПриИзменении(ЭтаФорма, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ФизлицоСтраховойНомерПФРПриИзменении(Элемент)

	СотрудникиКлиент.СотрудникиСтраховойНомерПФРПриИзменении(ЭтаФорма, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ВАрхивеПриИзменении(Элемент)

	СотрудникиКлиентСервер.УстановитьИнфоНадпись(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриемаПриИзменении(Элемент)

	СотрудникиКлиентСервер.УстановитьИнфоНадпись(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура ДатаУвольненияПриИзменении(Элемент)

	СотрудникиКлиентСервер.УстановитьИнфоНадпись(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура ТекущаяТарифнаяСтавкаПриИзменении(Элемент)

	СотрудникиКлиентСервер.УстановитьИнфоНадпись(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура УточнениеНаименованияПриИзменении(Элемент)

	СотрудникиКлиент.СформироватьНаименованиеСотрудника(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВидЗанятостиПриИзменении(Элемент)

	СотрудникиКлиент.ПроверитьКонфликтыВидаЗанятостиССуществующимиСотрудниками(Сотрудник.Ссылка, Сотрудник.ФизическоеЛицо, ТекущаяОрганизация, Сотрудник.ВидЗанятости, ДатаПриема);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Редактирование ФИО

&НаКлиенте
Процедура ИзменитьФИО(Команда)

	СотрудникиКлиент.СотрудникИзменилФИОНажатие(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ФИОФизическихЛицИстория(Команда)

	СотрудникиКлиент.СотрудникиОткрытьФормуРедактированияИстории("ФИОФизическихЛиц", ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ФИОПриИзменении(Элемент)

	СотрудникиКлиент.ПриИзмененииФИОСотрудника(ЭтаФорма);
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

КонецПроцедуры

&НаКлиенте
Процедура ФизлицоПолПриИзменении(Элемент)

	СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Редактирование места рождения.

&НаКлиенте
Процедура ФизлицоДатаРожденияПриИзменении(Элемент)

	СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ЭтаФорма);
	СотрудникиКлиентСервер.УстановитьПодсказкуКДатеРождения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаДоступаПриИзменении(Элемент)

	СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Расширенные подсистемы

// Места работы

&НаКлиенте
Процедура ИсторияИзмененийМестаРаботы(Команда)

	ПараметрыОткрытия = Новый Структура("СсылкаНаСотрудника", СотрудникСсылка);
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаИсторииИзмененияМестаРаботы", ПараметрыОткрытия, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ЛичныеДанные(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.ЛичныеДанные"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаЗарплаты(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.ВыплатаЗарплаты"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогНаДоходы(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.НалогНаДоходы"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Страхование(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.Страхование"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыГПХ(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.ДоговорыГПХ"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияИУдержания(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.НачисленияИУдержания"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Отсутствия(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.Отсутствия"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КадровыеДокументы(Команда)
	
	СтандартнаяОбработка = Истина;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.ОткрытьФормуКадровыхПриказовВоеннослужащих(ЭтаФорма, СтандартнаяОбработка);
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		
		СотрудникиКлиент.ОткрытьДополнительнуюФорму(
			СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("ЖурналДокументов.КадровыеДокументы.ФормаСписка"), ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами.

&НаСервере
Функция АдресДанныхДополнительнойФормыНаСервере(ОписаниеДополнительнойФормы) Экспорт
	Возврат СотрудникиФормы.АдресДанныхДополнительнойФормы(ОписаниеДополнительнойФормы, ЭтаФорма);
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеИзХранилищаВФормуНаСервере(Параметр) Экспорт
	
	СотрудникиФормы.ПрочитатьДанныеИзХранилищаВФорму(
		ЭтаФорма,
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(Параметр.ИмяФормы),
		Параметр.АдресВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеДополнительнойФормы(ИмяФормы, Отказ) Экспорт
	
	СотрудникиФормы.СохранитьДанныеДополнительнойФормы(ЭтаФорма, ИмяФормы, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ВоинскийУчет(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.ВоинскийУчет"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбразованиеКвалификация(Команда)
	
	ДополнительныеПараметры = Новый Структура("ЗаписатьЭлемент", Истина);
	
	Если СозданиеНового И НЕ ЗначениеЗаполнено(Сотрудник.ФизическоеЛицо) Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
				|Переход к сведениям об образовании, квалификации возможен только после записи данных.
				|Данные будут записаны.'");
				
		Оповещение = Новый ОписаниеОповещения("ОбразованиеКвалификацияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);	
		
	Иначе 
		
		ДополнительныеПараметры.ЗаписатьЭлемент = Ложь;
		ОбразованиеКвалификацияЗавершение(Неопределено, ДополнительныеПараметры);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбразованиеКвалификацияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЗаписатьЭлемент И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.ОбразованиеКвалификация"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Семья(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.Семья"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КадровыйРезерв(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда
		МодульКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КадровыйРезервКлиент");
		МодульКлиент.ОткрытьФормуКадровыйРезерв(ЭтаФорма, ФизическоеЛицоСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОхранаТруда(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		МодульКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОхранаТрудаФормыКлиент");
		МодульКлиент.ОткрытьФормуПоОхранеТруда(ЭтаФорма, СотрудникСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИндивидуальныеЛьготы(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ЛьготыСотрудниковКлиент");
		Модуль.ОткрытьФормуИндивидуальныйПакетЛьгот(ЭтаФорма, ФизическоеЛицоСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТрудоваяДеятельность(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.ТрудоваяДеятельность"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппыСотрудников()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("ВыбранныеГруппы", СписокГруппСотрудников.ВыгрузитьЗначения());
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("СписокГруппСотрудниковОбработкаВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ГруппыСотрудников.ФормаВыбора", ПараметрыОткрытия, Элементы.СписокГруппСотрудников, , , , ОповещениеЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокГруппСотрудниковОбработкаВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		СписокГруппСотрудников.ЗагрузитьЗначения(Результат);
		Модифицированность = Истина;
		
		УстановитьОтображениеГруппВСотрудников();
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеГруппВСотрудников()
	
	ПоказыватьГруппыСотрудников = СписокГруппСотрудников.Количество() > 0;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокГруппСотрудников",
		"Видимость",
		ПоказыватьГруппыСотрудников);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокГруппСотрудниковДекорация",
		"Видимость",
		Не ПоказыватьГруппыСотрудников);
	
КонецПроцедуры

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте 
Процедура Подключаемый_ПросклонятьПредставлениеПоВсемПадежам() 
	
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставлениеПоВсемПадежам(ЭтотОбъект, ФизическоеЛицо.ФИО, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"), 1, 2), Неопределено));
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

#КонецОбласти


#Область ЗаписьЭлемента

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ОповещениеЗавершения = Неопределено, Отказ = Ложь) Экспорт 
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ЗаписьЭлементаСправочникаСотрудники");

	СотрудникиКлиент.СохранитьДанныеФорм(ЭтаФорма, Отказ, ЗакрытьПослеЗаписи);
	Если НЕ Проверяютсяоднофамильцы Тогда
		ПараметрыЗаписи = Новый Структура;
		СотрудникиКлиент.СотрудникиПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
