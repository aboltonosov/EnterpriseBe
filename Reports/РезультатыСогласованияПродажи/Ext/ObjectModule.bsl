﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ПараметрыОтчет")
			И Параметры.ПараметрыОтчет.Свойство("ДополнительныеПараметры") Тогда 
			
		Если Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "РезультатыСогласованияЗаказаКлиента" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Предмет", Параметры.ПараметрКоманды);
		ИначеЕсли Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "РезультатыСогласованияКоммерческогоПредложения" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Предмет", Параметры.ПараметрКоманды);
		ИначеЕсли Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "РезультатыСогласованияПродажи" Тогда
			Предметы = ОбщегоНазначения.ЗначениеРеквизитаОбъектов( Параметры.ПараметрКоманды, "Предмет");
			Для Каждого ТекЭлемент Из Предметы Цикл
				Если Не ЗначениеЗаполнено(ТекЭлемент.Значение) Тогда
					ТекстОшибки = НСтр("ru='В бизнес-процессе %1 не заполнен предмет. Отчет не будет сформирован.'");
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ТекЭлемент.Ключ);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
					Отказ = Истина;
				КонецЕсли;
			КонецЦикла;
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("СогласованиеПродажи", Параметры.ПараметрКоманды);
		ИначеЕсли Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "РезультатыСогласованияСоглашенияСКлиентами" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Предмет", Параметры.ПараметрКоманды);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли