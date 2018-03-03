﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ОтветПередЗаписью;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);

	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Валюта = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВариантРаспределения = НЕ ЗначениеЗаполнено(Объект.КоличествоМесяцев);
	ТекстЗаголовкаУпр = НСтр("ru = 'Упр. учет с НДС (%1)'");
	ТекстЗаголовкаРегл = НСтр("ru = 'Регл. учет без НДС (%1)'");
	Элементы.СуммаДокумента.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаУпр, Валюта);
	Элементы.СуммаДокументаРегл.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаРегл, ВалютаРегламентированногоУчета);
//++ НЕ УТ
	Элементы.ГруппаРаспределеноРегл.Видимость = Истина;
	Элементы.ГруппаРегл.Видимость = Истина;
	Элементы.РаспределениеРасходовГруппаРегл.Видимость = Истина;
//-- НЕ УТ
	СуммаДокументаДоКорректировки = Объект.СуммаДокумента;
	СуммаДокументаРеглДоКорректировки = Объект.СуммаДокументаРегл;
	СуммаДокументаПРДоКорректировки = Объект.СуммаДокументаПР;
	СуммаДокументаВРДоКорректировки = Объект.СуммаДокументаВР;
	Объект.СуммаДокумента = Объект.СуммаДокумента + ?(Параметры.Свойство("Сумма"), Параметры.Сумма, 0);
	Объект.СуммаДокументаРегл = Объект.СуммаДокументаРегл + ?(Параметры.Свойство("СуммаРегл"), Параметры.СуммаРегл, 0);
	Объект.СуммаДокументаПР = Объект.СуммаДокументаПР + ?(Параметры.Свойство("ПостояннаяРазница"), Параметры.ПостояннаяРазница, 0);
	Объект.СуммаДокументаВР = Объект.СуммаДокументаВР + ?(Параметры.Свойство("ВременнаяРазница"), Параметры.ВременнаяРазница, 0);
	Если СуммаДокументаДоКорректировки <> Объект.СуммаДокумента
		   ИЛИ СуммаДокументаРеглДоКорректировки <> Объект.СуммаДокументаРегл
		   ИЛИ СуммаДокументаПРДоКорректировки <> Объект.СуммаДокументаПР
		   ИЛИ СуммаДокументаВРДоКорректировки <> Объект.СуммаДокументаВР Тогда
		Модифицированность = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.РаспределениеРасходов);
		СтатьяРасходовПриИзмененииНаСервере();
	КонецЕсли;
	НастроитьФорму(ЭтотОбъект);
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.РаспределениеРасходов);
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовЗаказРеализация(Объект.РаспределениеРасходов);
	СтатьяРасходовПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	Если НеВыполнятьПроверкуПередЗаписью Тогда
		НеВыполнятьПроверкуПередЗаписью = Ложь;
		Возврат;
	КонецЕсли;
	
	ТабличнаяЧасть = "РаспределениеРасходов";
	
	Если Объект.СуммаДокумента = 0 Тогда
		Объект.СуммаДокумента = Объект[ТабличнаяЧасть].Итог("Сумма");
	КонецЕсли;
	Если Объект.СуммаДокументаРегл = 0 Тогда
		Объект.СуммаДокументаРегл = Объект[ТабличнаяЧасть].Итог("СуммаРегл");
	КонецЕсли;
	Если Объект.СуммаДокументаПР = 0 Тогда
		Объект.СуммаДокументаПР = Объект[ТабличнаяЧасть].Итог("ПостояннаяРазница");
	КонецЕсли;
	Если Объект.СуммаДокументаВР = 0 Тогда
		Объект.СуммаДокументаВР = Объект[ТабличнаяЧасть].Итог("ВременнаяРазница");
	КонецЕсли;
	Объект.КоличествоМесяцев = ?(ВариантРаспределения, 0, Объект.КоличествоМесяцев);
	ЭтоОтменаПроведения = ?(ПараметрыЗаписи.Свойство("РежимЗаписи"),
								  ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения,
								  Ложь);
	Если ОтветПередЗаписью = Неопределено Тогда
		ОтветПередЗаписью = Ложь;
	КонецЕсли;
	Если НЕ ОтветПередЗаписью И НЕ ЭтоОтменаПроведения
		И Объект[ТабличнаяЧасть].Количество() > 0
		И (Объект.СуммаДокумента <> Объект[ТабличнаяЧасть].Итог("Сумма")
			ИЛИ Объект.СуммаДокументаРегл <> Объект[ТабличнаяЧасть].Итог("СуммаРегл")
			ИЛИ Объект.СуммаДокументаПР <> Объект[ТабличнаяЧасть].Итог("ПостояннаяРазница")
			ИЛИ Объект.СуммаДокументаВР <> Объект[ТабличнаяЧасть].Итог("ВременнаяРазница")) Тогда
		
		Отказ = Истина;
		
		ДопПараметры = Новый Структура("ИмяТабличнойЧасти, ПараметрыЗаписи", ТабличнаяЧасть, ПараметрыЗаписи);
		ТекстВопроса = НСтр("ru = 'Суммы по строкам в табличной части не равны соответствующим суммам документа, пересчитать суммы документа?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПересчитатьСуммыДокументаПоРасшифровкеПлатежаЗавершение", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ОтветПередЗаписью = Ложь;
	
	ОбщегоНазначенияУТКлиент.ОбработатьЗаписьОбъектаВФорме(ЭтотОбъект, ПараметрыЗаписи, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммыДокументаПоРасшифровкеПлатежаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Свойство("ИмяТабличнойЧасти") Тогда
		ТабличнаяЧасть = Объект[ДополнительныеПараметры.ИмяТабличнойЧасти];
	Иначе
		ТабличнаяЧасть = Объект.РасшифровкаПлатежа;
	КонецЕсли;
	
	КодОтвета = РезультатВопроса;
	Если КодОтвета = КодВозвратаДиалога.Да Тогда
		ОтветПередЗаписью = Истина;
		Объект.СуммаДокумента = ТабличнаяЧасть.Итог("Сумма");
		Объект.СуммаДокументаРегл = ТабличнаяЧасть.Итог("СуммаРегл");
		Объект.СуммаДокументаПР = ТабличнаяЧасть.Итог("ПостояннаяРазница");
		Объект.СуммаДокументаВР = ТабличнаяЧасть.Итог("ВременнаяРазница");
		ОбщегоНазначенияУТКлиент.ОбработатьЗаписьОбъектаВФорме(ЭтаФорма, ДополнительныеПараметры.ПараметрыЗаписи, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.РаспределениеРасходов);
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовЗаказРеализация(Объект.РаспределениеРасходов);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_РаспределениеРасходовБудущихПериодов", ПараметрыЗаписи, Объект.Ссылка);
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	ОтветПередЗаписью = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ПринудительноЗакрытьФорму = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВариантРаспределения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КоличествоМесяцев");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("КонецПериода");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	СтатьяРасходовПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
		
	АналитикаРасходовЗаказРеализация = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация");
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаспределенияПриИзменении(Элемент)

	НастроитьФорму(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("ОбщаяФорма.ВыборАналитикиРасходов", , Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходов = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) И АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) И АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРаспределениеРасходов

&НаКлиенте
Процедура РаспределениеРасходовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		
		СуммаОстаток = Объект.СуммаДокумента - Объект.РаспределениеРасходов.Итог("Сумма");
		СуммаОстатокРегл = Объект.СуммаДокументаРегл - Объект.РаспределениеРасходов.Итог("СуммаРегл");
		СуммаОстатокПР = Объект.СуммаДокументаПР - Объект.РаспределениеРасходов.Итог("ПостояннаяРазница");
		СуммаОстатокВР = Объект.СуммаДокументаВР - Объект.РаспределениеРасходов.Итог("ВременнаяРазница");
		Элемент.ТекущиеДанные.Сумма = СуммаОстаток;
		Элемент.ТекущиеДанные.СуммаРегл = СуммаОстатокРегл;
		Элемент.ТекущиеДанные.ПостояннаяРазница = СуммаОстатокПР;
		Элемент.ТекущиеДанные.ВременнаяРазница = СуммаОстатокВР;
		
		КоличествоСтрок = Объект.РаспределениеРасходов.Количество();
		Если КоличествоСтрок > 1 Тогда
			Дата = ДобавитьМесяц(НачалоМесяца(Объект.РаспределениеРасходов[КоличествоСтрок - 2].Дата), 1);
			Элемент.ТекущиеДанные.Дата = Дата;
		Иначе
			Элемент.ТекущиеДанные.Дата = Объект.НачалоПериода;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеРасходовСтатьяРасходовПриИзменении(Элемент)
	
	РаспределениеРасходовСтатьяРасходовПриИзмененииНаСервере(КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура РаспределениеРасходовСтатьяРасходовПриИзмененииНаСервере(КэшированныеЗначения)
	
	СтрокаТаблицы = Объект.РаспределениеРасходов.НайтиПоИдентификатору(Элементы.РаспределениеРасходов.ТекущаяСтрока);
	
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна, ЗаполнитьПризнакАналитикаРасходовЗаказРеализация");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеРасходовАналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.РаспределениеРасходов.ТекущиеДанные;
	Если СтрокаТаблицы.АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("ОбщаяФорма.ВыборАналитикиРасходов", , Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеРасходовАналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.РаспределениеРасходов.ТекущиеДанные;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыбранноеЗначение);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеРасходовАналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеРасходовАналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьРаспределение(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("НачалоПериода", НСтр("ru='Начиная с даты'"));
	Если ВариантРаспределения Тогда
		СтруктураРеквизитов.Вставить("КонецПериода", НСтр("ru='По дату'"));
	Иначе
		СтруктураРеквизитов.Вставить("КоличествоМесяцев", НСтр("ru='Количество месяцев'"));
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьРаспределениеЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Объект.РаспределениеРасходов, 
		СтруктураРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРаспределениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РаспределитьРасходы("ПоКалендарнымДням");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРаспределениеПоМесяцам(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("НачалоПериода", НСтр("ru='Начиная с даты'"));
	Если ВариантРаспределения Тогда
		СтруктураРеквизитов.Вставить("КонецПериода", НСтр("ru='По дату'"));
	Иначе
		СтруктураРеквизитов.Вставить("КоличествоМесяцев", НСтр("ru='Количество месяцев'"));
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьРаспределениеПоМесяцамЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Объект.РаспределениеРасходов, 
		СтруктураРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРаспределениеПоМесяцамЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РаспределитьРасходы("ПоМесяцам");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьиРасходов(Команда)
	
	ЗаполнитьСтатьиРасходовВТабличнойЧасти(Элементы.РаспределениеРасходов.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодразделение(Команда)
	
	ЗаполнитьПодразделениеВТабличнойЧасти(Элементы.РаспределениеРасходов.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

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

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	РеквизитыПроверкиАналитик = Новый Массив;
	РеквизитыПроверкиАналитик.Добавить("СтатьяРасходов, АналитикаРасходов");
	РеквизитыПроверкиАналитик.Добавить(Новый Структура("РаспределениеРасходов"));
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(
		УсловноеОформление, РеквизитыПроверкиАналитик);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КонецПериода.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантРаспределения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.КонецПериода");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КоличествоМесяцев.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантРаспределения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.КоличествоМесяцев");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
КонецПроцедуры

&НаСервере
Функция РазностьДатВДнях(Знач Дата1, Знач Дата2)
	
	ДлинаСуток = 86400; // в секундах
	Возврат Окр((НачалоДня(Дата1) - НачалоДня(Дата2)) / ДлинаСуток);
	
КонецФункции

&НаСервере
Процедура РаспределитьРасходы(СпособРаспределения)
	
	Объект.РаспределениеРасходов.Очистить();
	
	РаспределениеОтрицательнойСуммы = Объект.СуммаДокумента < 0;
	РаспределениеОтрицательнойСуммыРегл = Объект.СуммаДокументаРегл < 0;
	РаспределениеОтрицательнойСуммыПР = Объект.СуммаДокументаПР < 0;
	РаспределениеОтрицательнойСуммыВР = Объект.СуммаДокументаВР < 0;
	
	СуммаКРаспределению = Объект.СуммаДокумента;
	СуммаКРаспределениюРегл = Объект.СуммаДокументаРегл;
	СуммаКРаспределениюПР = Объект.СуммаДокументаПР;
	СуммаКРаспределениюВР = Объект.СуммаДокументаВР;
	Если Объект.НачалоПериода = НачалоМесяца(Объект.НачалоПериода) Тогда
		Если НЕ ВариантРаспределения Тогда
			Объект.КонецПериода = КонецМесяца(ДобавитьМесяц(Объект.НачалоПериода, Объект.КоличествоМесяцев - 1));
			ВсегоМесяцев = Объект.КоличествоМесяцев - 1;
		Иначе
			ТекущийМесяц = НачалоМесяца(Объект.НачалоПериода);
			ВсегоМесяцев = 0;
			Пока КонецМесяца(ТекущийМесяц) < КонецМесяца(Объект.КонецПериода) Цикл
				ТекущийМесяц = ДобавитьМесяц(ТекущийМесяц, 1);
				ВсегоМесяцев = ВсегоМесяцев + 1;
			КонецЦикла;
		КонецЕсли;
	Иначе
		Если НЕ ВариантРаспределения Тогда
			Объект.КонецПериода = ДобавитьМесяц(Объект.НачалоПериода, Объект.КоличествоМесяцев) - 1;
			ВсегоМесяцев = Объект.КоличествоМесяцев;
		Иначе
			ТекущийМесяц = НачалоМесяца(Объект.НачалоПериода);
			ВсегоМесяцев = 0;
			Пока КонецМесяца(ТекущийМесяц) < КонецМесяца(Объект.КонецПериода) Цикл
				ТекущийМесяц = ДобавитьМесяц(ТекущийМесяц, 1);
				ВсегоМесяцев = ВсегоМесяцев + 1;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ДатаНачалаСписания = НачалоДня(Объект.НачалоПериода);
	ДатаОкончанияСписания = КонецДня(Объект.КонецПериода);
	
	СтатьяРасходовРаспределение = ПланыВидовХарактеристик.СтатьиРасходов.ПолучитьРеквизитыСтатьиРасходов(Объект.СтатьяРасходов).СтатьяРасходов;
	
	ДоляПоследнегоМесяца = День(ДатаОкончанияСписания) / День(КонецМесяца(ДатаОкончанияСписания));
	
	Для Счетчик = 0 По ВсегоМесяцев Цикл
		
		Если Счетчик <> 0 Тогда
			ДатаНачалаСписания = НачалоМесяца(ДобавитьМесяц(ДатаНачалаСписания, 1));
		КонецЕсли;
		
		Если СпособРаспределения = "ПоКалендарнымДням" Тогда
			КоличествоДней = РазностьДатВДнях(ДатаОкончанияСписания, ДатаНачалаСписания) + 1;
			ЦенаДня = СуммаКРаспределению / КоличествоДней;
			ЦенаДняРегл = СуммаКРаспределениюРегл / КоличествоДней;
			ЦенаДняПР = СуммаКРаспределениюПР / КоличествоДней;
			ЦенаДняВР = СуммаКРаспределениюВР / КоличествоДней;
			Если КонецМесяца(ДатаОкончанияСписания) = КонецМесяца(ДатаНачалаСписания) Тогда 
				КоличествоДнейТекущегоМесяца = День(ДатаОкончанияСписания); 
				КоличествоДней = КоличествоДнейТекущегоМесяца;
				СуммаСписания = СуммаКРаспределению;
				СуммаСписанияРегл = СуммаКРаспределениюРегл;
				СуммаСписанияПР = СуммаКРаспределениюПР;
				СуммаСписанияВР = СуммаКРаспределениюВР;
			Иначе	
				КоличествоДнейТекущегоМесяца = РазностьДатВДнях(КонецМесяца(ДатаНачалаСписания), ДатаНачалаСписания) + 1; 
				СуммаСписания = ЦенаДня * КоличествоДнейТекущегоМесяца;
				СуммаСписанияРегл = ЦенаДняРегл * КоличествоДнейТекущегоМесяца;
				СуммаСписанияПР = ЦенаДняПР * КоличествоДнейТекущегоМесяца;
				СуммаСписанияВР = ЦенаДняВР * КоличествоДнейТекущегоМесяца;
			КонецЕсли;
			
		Иначе
			Если КонецМесяца(ДатаНачалаСписания) = КонецМесяца(ДатаОкончанияСписания) Тогда
				ДоляТекущегоМесяца = ДоляПоследнегоМесяца;
				КоличествоМесяцев  = ДоляПоследнегоМесяца;
			Иначе
				ДоляТекущегоМесяца = (РазностьДатВДнях(КонецМесяца(ДатаНачалаСписания), ДатаНачалаСписания) + 1) / День(КонецМесяца(ДатаНачалаСписания));
				КоличествоМесяцевСередины = 0;
				ТекущаяДата = ДобавитьМесяц(КонецМесяца(ДатаНачалаСписания), 1);
				Пока КонецМесяца(ДатаОкончанияСписания) >= ТекущаяДата Цикл
					КоличествоМесяцевСередины = КоличествоМесяцевСередины + 1;
					ТекущаяДата = ДобавитьМесяц(ТекущаяДата, 1);
				КонецЦикла;
				КоличествоМесяцев = КоличествоМесяцевСередины - 1 + ДоляПоследнегоМесяца + ДоляТекущегоМесяца;
			КонецЕсли;
			СуммаСписания = ?(КоличествоМесяцев = 0, 0, Окр(СуммаКРаспределению * ДоляТекущегоМесяца / КоличествоМесяцев, 2, 1));
			СуммаСписанияРегл = ?(КоличествоМесяцев = 0, 0, Окр(СуммаКРаспределениюРегл * ДоляТекущегоМесяца / КоличествоМесяцев, 2, 1));
			СуммаСписанияПР = ?(КоличествоМесяцев = 0, 0, Окр(СуммаКРаспределениюПР * ДоляТекущегоМесяца / КоличествоМесяцев, 2, 1));
			СуммаСписанияВР = ?(КоличествоМесяцев = 0, 0, Окр(СуммаКРаспределениюВР * ДоляТекущегоМесяца / КоличествоМесяцев, 2, 1));
		КонецЕсли;
		
		НоваяСтрока = Объект.РаспределениеРасходов.Добавить();
		НоваяСтрока.Дата = ДатаНачалаСписания;
		
		Если НЕ РаспределениеОтрицательнойСуммы Тогда
			НоваяСтрока.Сумма = Мин(СуммаСписания, СуммаКРаспределению);
		Иначе
			НоваяСтрока.Сумма = Макс(СуммаСписания, СуммаКРаспределению);
		КонецЕсли;
		Если НЕ РаспределениеОтрицательнойСуммыРегл Тогда
			НоваяСтрока.СуммаРегл = Мин(СуммаСписанияРегл, СуммаКРаспределениюРегл);
		Иначе
			НоваяСтрока.СуммаРегл = Макс(СуммаСписанияРегл, СуммаКРаспределениюРегл);
		КонецЕсли;
		Если НЕ РаспределениеОтрицательнойСуммыПР Тогда
			НоваяСтрока.ПостояннаяРазница = Мин(СуммаСписанияПР, СуммаКРаспределениюПР);
		Иначе
			НоваяСтрока.ПостояннаяРазница = Макс(СуммаСписанияПР, СуммаКРаспределениюПР);
		КонецЕсли;
		Если НЕ РаспределениеОтрицательнойСуммыВР Тогда
			НоваяСтрока.ВременнаяРазница = Мин(СуммаСписанияВР, СуммаКРаспределениюВР);
		Иначе
			НоваяСтрока.ВременнаяРазница = Макс(СуммаСписанияВР, СуммаКРаспределениюВР);
		КонецЕсли;
		
		НоваяСтрока.Подразделение = Объект.Подразделение;
		Если ЗначениеЗаполнено(СтатьяРасходовРаспределение) Тогда
			НоваяСтрока.СтатьяРасходов = СтатьяРасходовРаспределение;
			НоваяСтрока.АналитикаРасходов = Объект.АналитикаРасходов;
		КонецЕсли;
		
		СуммаКРаспределению = СуммаКРаспределению - НоваяСтрока.Сумма;
		СуммаКРаспределениюРегл = СуммаКРаспределениюРегл - НоваяСтрока.СуммаРегл;
		СуммаКРаспределениюПР = СуммаКРаспределениюПР - НоваяСтрока.ПостояннаяРазница;
		СуммаКРаспределениюВР = СуммаКРаспределениюВР - НоваяСтрока.ВременнаяРазница;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьиРасходовВТабличнойЧасти(ВыделенныеСтроки)
	
	Если Объект.РаспределениеРасходов.Количество() > 0 Тогда
	
		МассивВариантов = Новый Массив;
		МассивВариантов.Добавить("НаНаправленияДеятельности");
		МассивВариантов.Добавить("НаПрочиеАктивы");
		МассивВариантов.Добавить("НаРасходыБудущихПериодов");
		МассивВариантов.Добавить("НеРаспределять");
		//++ НЕ УТ
		МассивВариантов.Добавить("НаПроизводственныеЗатраты");
		//-- НЕ УТ

		ОткрытьФорму(
			"ПланВидовХарактеристик.СтатьиРасходов.Форма.ФормаВыбораСтатьиИАналитики",
			Новый Структура("ВариантыРаспределенияРасходов", МассивВариантов),
			ЭтаФорма,,,, 
			Новый ОписаниеОповещения("ЗаполнитьСтатьиРасходовВТабличнойЧастиЗавершение",
				ЭтотОбъект,
				Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьиРасходовВТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	Структура = Результат;
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна, ЗаполнитьПризнакАналитикаРасходовЗаказРеализация");
	Если ЗначениеЗаполнено(Структура) Тогда
		Если ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
			Для Каждого Строка Из ВыделенныеСтроки Цикл
				СтрокаТаблицы = Объект.РаспределениеРасходов.НайтиПоИдентификатору(Строка);
				Если СтрокаТаблицы <> Неопределено Тогда
					СтрокаТаблицы.СтатьяРасходов = Структура.СтатьяРасходов;
					СтрокаТаблицы.АналитикаРасходов = Структура.АналитикаРасходов;
					ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого СтрокаТаблицы Из Объект.РаспределениеРасходов Цикл
				СтрокаТаблицы.СтатьяРасходов = Структура.СтатьяРасходов;
				СтрокаТаблицы.АналитикаРасходов = Структура.АналитикаРасходов;
				ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФорму(Форма)

	Форма.Элементы.ГруппаПериоды.ТекущаяСтраница = ?(Форма.ВариантРаспределения,
																  Форма.Элементы.ГруппаПериодПроизвольный,
																  Форма.Элементы.ГруппаПериодМесяц);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодразделениеВТабличнойЧасти(ВыделенныеСтроки)
	
	Если Объект.РаспределениеРасходов.Количество() > 0 Тогда
	
		ОтборПоОрганизации = Новый Структура;
		ОтборПоОрганизации.Вставить("Организация", Объект.Организация);
		ОткрытьФорму(
			"Справочник.СтруктураПредприятия.Форма.ФормаВыбора",
			ОтборПоОрганизации,
			ЭтаФорма,,,, 
			Новый ОписаниеОповещения("ЗаполнитьПодразделениеВТабличнойЧастиЗавершение",
				ЭтотОбъект,
				Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодразделениеВТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	Если ЗначениеЗаполнено(Результат) Тогда
		Если ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
			Для Каждого Строка Из ВыделенныеСтроки Цикл
				СтрокаТаблицы = Объект.РаспределениеРасходов.НайтиПоИдентификатору(Строка);
				Если СтрокаТаблицы <> Неопределено Тогда
					СтрокаТаблицы.Подразделение = Результат;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого СтрокаТаблицы Из Объект.РаспределениеРасходов Цикл
				СтрокаТаблицы.Подразделение = Результат;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти