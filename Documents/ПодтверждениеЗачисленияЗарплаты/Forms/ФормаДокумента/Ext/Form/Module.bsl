﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// ERP-БЗКР Проект 3063
	Если Не Истина Тогда
		УстановитьДоступностьЭлементов();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ERP-БЗКР Проект 3063
	Если Не Истина Тогда
		Если Параметры.Ключ.Пустая() Тогда
			ПодключитьОбработчикОжидания("ЗагрузитьПодтвержденияБанка", 0.1, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СостоянияДокументовЗачисленияЗарплаты"));
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
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
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "ТолькоПросмотр", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Подразделение", "ТолькоПросмотр", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПервичныйДокумент", "ТолькоПросмотр", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗарплатныйПроект", "ТолькоПросмотр", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаНомер", "ТолькоПросмотр", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Сотрудники", "ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПодтвержденияБанка()
	
	ПараметрыЗагрузки = ОбменСБанкамиПоЗарплатнымПроектамКлиент.ПараметрыЗагрузкиФайловИзБанка();
	ПараметрыЗагрузки.МножественныйВыбор = Ложь;
	ПараметрыЗагрузки.ОповещениеЗавершения = Новый ОписаниеОповещения("ЗагрузитьПодтвержденияБанкаЗавершение", ЭтотОбъект);
	
	ОбменСБанкамиПоЗарплатнымПроектамКлиент.ЗагрузитьФайлыИзБанка(ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПодтвержденияБанкаЗавершение(Результат, ПараметрыЗагрузки) Экспорт
	
	ПомещенныеФайлы = Результат.ПомещенныеФайлы;
	
	Если ПомещенныеФайлы.Количество() = 0 Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	СообщениеОбОшибке = Неопределено;
	СозданныеДокументы = ЗагрузитьПодтвержденияИзБанкаНаСервере(ПомещенныеФайлы, СообщениеОбОшибке);
	Если СозданныеДокументы.Количество() = 0 Тогда
		ПоказатьПредупреждение(, СообщениеОбОшибке);
		Закрыть();
		Возврат;
	КонецЕсли;
	
	ОбменСБанкамиПоЗарплатнымПроектамКлиент.ЗагрузитьПодтвержденияБанкаЗавершение(СозданныеДокументы);
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьПодтвержденияИзБанкаНаСервере(МассивИменФайлов, СообщениеОбОшибке)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументыПодтверждения = ОбменСБанкамиПоЗарплатнымПроектам.ЗагрузитьПодтвержденияИзБанка(МассивИменФайлов, ДокументОбъект);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	Если ДокументыПодтверждения.Количество() = 0 Тогда
		СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
		Если СообщенияПользователю.Количество() > 0 Тогда
			СообщениеОбОшибке = СообщенияПользователю.Получить(0).Текст;
		Иначе
			СообщениеОбОшибке = НСтр("ru = 'Неверный формат файла.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДокументыПодтверждения;
	
КонецФункции

#КонецОбласти
