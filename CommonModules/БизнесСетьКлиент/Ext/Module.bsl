﻿
#Область СлужебныйПрограммныйИнтерфейс

// Загрузка документа из сервиса в информационную базу.
//
Процедура ЗагрузитьЭлектронныйДокумент(ПараметрыЗагрузки, Отказ) Экспорт
	
	СопоставлятьНоменклатуру = ПараметрыЗагрузки.СопоставлятьНоменклатуру;
	Если СопоставлятьНоменклатуру = Неопределено Тогда
		ОбменСКонтрагентамиКлиентПереопределяемый.СопоставлятьНоменклатуруПередЗаполнениемДокумента(СопоставлятьНоменклатуру);
	КонецЕсли;
	
	Если СопоставлятьНоменклатуру Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВыполнялосьСопоставление", Ложь);
		ДополнительныеПараметры.Вставить("ОтказЗаполнения", Ложь);
		ДополнительныеПараметры.Вставить("Контекст", ПараметрыЗагрузки);
		ДополнительныеПараметры.Вставить("Отказ", Ложь);
		
		ОбработчикОповещенияПередЗаполнением = Новый ОписаниеОповещения("ЗаполнитьДокументПослеСопоставления",
			ЭтотОбъект,	ДополнительныеПараметры);
			
		СопоставитьНоменклатуру(ПараметрыЗагрузки, ОбработчикОповещенияПередЗаполнением);
		
		Если ДополнительныеПараметры.Отказ Тогда
			Отказ = Истина;
		КонецЕсли;
		
		#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если Не ДополнительныеПараметры.ВыполнялосьСопоставление Тогда
			ЗагрузитьДокументВИБ(ПараметрыЗагрузки, СопоставлятьНоменклатуру, Отказ);
		КонецЕсли;
		#Иначе
		// Сопоставление номенклатуры отменено для документа при вызове сопоставления.
		Если ПараметрыЗагрузки.СопоставлятьНоменклатуру = Ложь Тогда
			ЗагрузитьДокументВИБ(ПараметрыЗагрузки, СопоставлятьНоменклатуру, Отказ);
		КонецЕсли;
		#КонецЕсли
			
	Иначе
		
		ЗагрузитьДокументВИБ(ПараметрыЗагрузки, СопоставлятьНоменклатуру, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

// Асинхронная процедура. Загрузка данных после сопоставления номенклатуры.
//
Процедура ЗаполнитьДокументПослеСопоставления(Результат, ДополнительныеПараметры) Экспорт
	
	ОтказЗаполнения = ДополнительныеПараметры.ОтказЗаполнения;
	Если ОтказЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнялосьСопоставление = ДополнительныеПараметры.ВыполнялосьСопоставление;
	ОбновитьСтруктуруРазбора = ВыполнялосьСопоставление;
	
	ЗагрузитьДокументВИБ(ДополнительныеПараметры.Контекст, Истина, ДополнительныеПараметры.Отказ, ВыполнялосьСопоставление);
	
КонецПроцедуры

// Команда открытия формы отправки документа через Бизнес-сеть.
Процедура ОтправитьЧерезБизнесСеть(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОтправитьЧерезБизнесСетьПродолжить", БизнесСетьКлиент, ПараметрКоманды);
	ЭлектронноеВзаимодействиеКлиентПереопределяемый.ВыполнитьПроверкуПроведенияДокументов(ПараметрКоманды,
		ОбработчикОповещения, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

// Асинхронная процедура.
Процедура ОтправитьЧерезБизнесСетьПродолжить(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	Если ПараметрКоманды.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'")
	КонецЕсли;
	
	Организация = Неопределено;
	Отказ = Ложь;
	ТекстОшибки = "";
	ВозможнаОтправка = БизнесСетьВызовСервера.ВозможнаОтправкаДокумента(ПараметрКоманды, Организация, ТекстОшибки, Отказ);
	Если Отказ Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
		Возврат;
	ИначеЕсли Не ВозможнаОтправка Тогда
		ТекстВопроса = НСтр("ru='Организация ""%1"" не подключена к сервису 1С:Бизнес-сеть. Подключить сейчас?'");
		ТекстВопроса = СтрШаблон(ТекстВопроса, Организация);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьОрганизациюПослеВопроса", ЭтотОбъект, Организация);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("МассивСсылокНаОбъект", ПараметрКоманды);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаДокумента", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

// Команда загрузки документа через сервис Бизнес-сеть.
//
Процедура ЗагрузитьЧерезБизнесСеть(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("РежимЗагрузкиДокументов", Истина);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ВходящиеДокументы", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

// Открытие формы профиля участника 1С:Бизнес-сеть.
//
// Параметры:
//   ПараметрыОткрытия - Ссылка - ссылка на организацию или контрагента.
//
Процедура ОткрытьПрофильУчастника(ПараметрыОткрытия) Экспорт
	
	Отказ = Ложь;
	Результат = Неопределено;
	ПараметрыУчастника = Новый Структура;
	
	УчастникЯвляетсяОрганизацией = Ложь;
	Если ПараметрыОткрытия.Свойство("Организация") И ЗначениеЗаполнено(ПараметрыОткрытия.Организация)  Тогда
		Ссылка = ПараметрыОткрытия.Организация;
		УчастникЯвляетсяОрганизацией = Истина;
	ИначеЕсли ПараметрыОткрытия.Свойство("Контрагент") И ЗначениеЗаполнено(ПараметрыОткрытия.Контрагент) Тогда
		Ссылка = ПараметрыОткрытия.Контрагент;
	Иначе
		Ссылка = Неопределено;
	КонецЕсли;
	
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("Ссылка", Ссылка);
	ПараметрыКоманды.Вставить("ИНН", ?(ПараметрыОткрытия.Свойство("ИНН"), ПараметрыОткрытия.ИНН, ""));
	ПараметрыКоманды.Вставить("КПП", ?(ПараметрыОткрытия.Свойство("КПП"), ПараметрыОткрытия.КПП, ""));
	
	БизнесСетьВызовСервера.ПолучитьРеквизитыУчастника(ПараметрыКоманды, Результат, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.КодСостояния = 200 Тогда
		ПараметрыУчастника = Результат.Данные;
		ПараметрыУчастника.Вставить("Ссылка", Ссылка);
	ИначеЕсли Результат.КодСостояния = 404 Тогда
		Если ЗначениеЗаполнено(Ссылка) Тогда
			Если УчастникЯвляетсяОрганизацией Тогда
				ТекстВопроса = НСтр("ru='Организация ""%1"" не подключена к сервису 1С:Бизнес-сеть. Подключить сейчас?'");
				ТекстВопроса = СтрШаблон(ТекстВопроса, Ссылка);
				ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьОрганизациюПослеВопроса", ЭтотОбъект, Ссылка);
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Иначе
				ТекстВопроса = НСтр("ru='Контрагент ""%1"" не подключен к сервису 1С:Бизнес-сеть.
					|Направить приглашение подключения?'");
				ТекстВопроса = СтрШаблон(ТекстВопроса, Ссылка);
				ПараметрыОткрытия = Новый Структура("Контрагент", Ссылка);
				ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьКонтрагентаПослеВопроса", ЭтотОбъект, ПараметрыОткрытия);
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
		Иначе
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Участник не зарегистрирован в сервисе 1С:Бизнес-сеть.'"));
		КонецЕсли;
		Возврат;
	Иначе
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияПрофиля = Новый Структура("Участник, ИНН, КПП");
	ПараметрыОткрытияПрофиля.Участник = ПараметрыУчастника;
	ПараметрыУчастника.Свойство("ИНН", ПараметрыОткрытияПрофиля.ИНН);
	ПараметрыУчастника.Свойство("КПП", ПараметрыОткрытияПрофиля.КПП);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПрофильУчастника", ПараметрыОткрытияПрофиля, ЭтотОбъект);
	
КонецПроцедуры

// Асинхронная процедура.
Процедура ПодключитьКонтрагентаПослеВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаПриглашения", Параметры,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Асинхронная процедура.
Процедура ПодключитьОрганизациюПослеВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ссылка", Параметры);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПодключениеУчастников", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Загрузка электронного документа в информационную базу.
//
Процедура ЗагрузитьДокументВИБ(Контекст, СопоставлятьНоменклатуруПередЗаполнениемДокумента, Отказ, ОбновитьСтруктуруРазбора = Ложь)
	
	ТекстСообщения = "";
	Если Контекст.Свойство("ДокументИБ") Тогда
		ДокументСсылка = Контекст.ДокументИБ;
	Иначе
		ДокументСсылка = Неопределено;
	КонецЕсли;
	
	БизнесСетьВызовСервера.СформироватьДокументИБ(Контекст, ДокументСсылка, ТекстСообщения, Истина, ОбновитьСтруктуруРазбора, Отказ);
	
	Если Отказ ИЛИ Не ЗначениеЗаполнено(ДокументСсылка) Тогда
		Если Не ПустаяСтрока(ТекстСообщения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
		
	ТекстОповещения	= НСтр("ru = 'Загрузка выполнена.'");
	ТекстПояснения	= НСтр("ru = 'Загружен документ через сервис 1С:Бизнес-сеть.'");
	ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(ДокументСсылка), ТекстПояснения, БиблиотекаКартинок.БизнесСеть);
	
	МассивОповещения = Новый Массив;
	МассивОповещения.Добавить(ДокументСсылка);
	Оповестить("ОбновитьДокументИБПослеЗаполнения", МассивОповещения);
	
	// Открыть форму документ из формы просмотра, если он новый.
	Если НЕ ЗначениеЗаполнено(Контекст.ДокументИБ) Тогда
		ПоказатьЗначение(Неопределено, ДокументСсылка);
	КонецЕсли;
	
	Контекст.ДокументИБ = ДокументСсылка;
	ОповеститьОбИзменении(ДокументСсылка);
	Оповестить("ОбновитьСписокВходящихДокументов1СБизнесСеть");
	
КонецПроцедуры

// Открытие формы сопоставления номенклатуры при загрузке.
//
Процедура СопоставитьНоменклатуру(Контекст, ОбработчикОповещения)
	
	СтруктураЭД = Новый Структура;
	СтруктураЭД.Вставить("ВидЭД",              Контекст.ВидЭД);
	СтруктураЭД.Вставить("СпособОбменаЭД",     ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.БыстрыйОбмен"));
	СтруктураЭД.Вставить("Контрагент",         Контекст.Контрагент);
	СтруктураЭД.Вставить("ДанныеФайлаРазбора", Контекст.ДанныеФайлаРазбора);
	СтруктураЭД.Вставить("НаправлениеЭД",      ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
	СтруктураЭД.Вставить("ВладелецФайла",      ?(Контекст.РежимЗаполненияДокумента, Контекст.ДокументИБ, Неопределено));
	
	СтруктураПараметров = ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьПараметрыФормыСопоставленияНоменклатуры(СтруктураЭД);
	
	Если ЗначениеЗаполнено(СтруктураПараметров) Тогда
		ОткрытьФорму(СтруктураПараметров.ИмяФормы, СтруктураПараметров.ПараметрыОткрытияФормы,,,,, ОбработчикОповещения);
	Иначе
		Контекст.СопоставлятьНоменклатуру = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
