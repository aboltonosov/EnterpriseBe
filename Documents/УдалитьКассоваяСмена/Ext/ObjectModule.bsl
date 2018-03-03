﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		
	Иначе
		
		КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторПоУмолчанию();
		Если КассаККМ <> Неопределено Тогда
			ЗаполнитьДокументПоКассеККМ(КассаККМ);
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТипКассы = Справочники.КассыККМ.РеквизитыКассыККМ(КассаККМ).ТипКассы;
	
	ОткрытаяКассоваяСмена = РозничныеПродажи.ПолучитьОткрытуюКассовуюСмену(КассаККМ, Ссылка, НачалоКассовойСмены, ОкончаниеКассовойСмены);
	Если ОткрытаяКассоваяСмена <> Неопределено Тогда
		
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru='По данной кассе на дату %Дата% уже зарегистрирован %КассоваяСмена%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Дата);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%КассоваяСмена%", ОткрытаяКассоваяСмена);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОкончаниеКассовойСмены)
		 И ЗначениеЗаполнено(СтатусКассовойСмены)
		 И СтатусКассовойСмены <> Перечисления.СтатусыКассовойСмены.Открыта Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Окончание смены"" не заполнено'"), ЭтотОбъект, "ОкончаниеКассовойСмены");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОкончаниеКассовойСмены)
		 И ОкончаниеКассовойСмены < НачалоКассовойСмены Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Время начала кассовой смены больше времени окончания кассовой смены'"), ЭтотОбъект, "ОкончаниеКассовойСмены");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтатусКассовойСмены)
		 И СтатусКассовойСмены = Перечисления.СтатусыКассовойСмены.Открыта
		 И НачалоКассовойСмены <> Дата Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Время начала кассовой смены отличается от даты документа'"), ЭтотОбъект, "НачалоКассовойСмены");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтатусКассовойСмены)
		 И СтатусКассовойСмены <> Перечисления.СтатусыКассовойСмены.Открыта
		 И ОкончаниеКассовойСмены <> Дата Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Время окончания кассовой смены отличается от даты документа'"), ЭтотОбъект, "ОкончаниеКассовойСмены");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	
	Кассир = Пользователи.ТекущийПользователь();
	
	НалогообложениеНДС = Справочники.Организации.НалогообложениеНДС(
		Организация,
		Склад,
		Дата);
	
	НачалоКассовойСмены    = НачалоДня(ТекущаяДата());
	ОкончаниеКассовойСмены = КонецДня(ТекущаяДата());
	
КонецПроцедуры

// Заполняет отчет о розничных продажах в соответствии с отбором.
//
// Параметры
//  ДанныеЗаполнения - Структура со значениями отбора
//
Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
		
		КассаККМ = ДанныеЗаполнения.КассаККМ;
		ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет документ по кассе ККМ 
//
Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ)
	
	РеквизитыКассыККМ = Справочники.КассыККМ.РеквизитыКассыККМ(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыКассыККМ);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
