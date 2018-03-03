﻿
&НаКлиенте
Перем КэшированныеЗначения;

&НаСервере
Перем КэшированныеЗначения;


#Область ОбработчикиСобытийФормы

// 4D:ERP для Беларуси, ВладимирР, 21.09.2015 14:30:43 
// Учет бланков строгой отчетности, №10038
// {
&НаКлиенте
Процедура НачальныйНомерБСОПриИзменении(Элемент)
	УчетБланковСтрогойОтчетностиКлиент.ПересчитатьНачальныйКонечныйНомерПриИзменении(Элементы, "Товары", "НачальныйНомерБСО", "КонечныйНомерБСО", "Количество", "НачальныйНомерБСОПриИзменении", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КонечныйНомерБСОПриИзменении(Элемент)
	УчетБланковСтрогойОтчетностиКлиент.ПересчитатьНачальныйКонечныйНомерПриИзменении(Элементы, "Товары", "НачальныйНомерБСО", "КонечныйНомерБСО", "Количество", "КонечныйНомерБСОПриИзменении", Ложь);
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодборБСО(Адрес)
	ПолныйОбъект = РеквизитФормыВЗначение("Объект");
	УчетБланковСтрогойОтчетностиСервер.НайтиДобавитьСтрокиБСО(ПолныйОбъект, Адрес);
	ЗначениеВРеквизитФормы(ПолныйОбъект, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ПодборБСО(Команда)
	УчетБланковСтрогойОтчетностиКлиент.ОткрытьПодборБланковСтрогойОтчетности(Объект, ЭтаФорма);
КонецПроцедуры
// }
// 4D

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("Автотест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	
	// 4D:ERP для Беларуси, ВладимирР, 21.09.2015 14:30:43 
	// Учет бланков строгой отчетности, №10038
	// {
	УчетБланковСтрогойОтчетностиСервер.ДобавитьГруппуБСО(ЭтаФорма);
	// }
	// 4D
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ПартииТМЦВЭксплуатации.Форма.ФормаПодбора" Тогда
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Если Тип("Структура") = ТипЗнч(ЭлементМассива) Тогда
					ЗаполнитьЗначенияСвойств(Объект.Товары.Добавить(), ЭлементМассива);
				Иначе
					Объект.Товары.Добавить().ПартияТМЦВЭксплуатации = ЭлементМассива;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// 4D:ERP для Беларуси, ВладимирР, 21.09.2015 14:30:43 
	// Учет бланков строгой отчетности, №10038
	// {
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("УникальныйИдентификаторБСО") И ВыбранноеЗначение.УникальныйИдентификаторБСО = УникальныйИдентификатор Тогда
		ОбработатьПодборБСО(ВыбранноеЗначение.Адрес);
	КонецЕсли;
	// }
	// 4D

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	// 4D:ERP для Беларуси, ВладимирР, 21.09.2015 14:30:43 
	// Учет бланков строгой отчетности, №10038
	// {
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если Объект.РежимИспользованияБСО Тогда
			Если УчетБланковСтрогойОтчетностиКлиент.ПустоеЗначениеРеквизитовБСО(Объект, "Товары") Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			СтруктураВозврата = УчетБланковСтрогойОтчетностиСервер.ПроверитьВозможностьСписанияБСО(ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка"), Объект.Товары, Объект.Дата, ИмяФормы);
			Если СтруктураВозврата.Отказ Тогда
				Отказ = СтруктураВозврата.Отказ;
				УчетБланковСтрогойОтчетностиКлиент.ВывестиСообщениеПользователю(СтруктураВозврата);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// }
	// 4D
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПроверитьЗаполнитьПартииТМЦВЭксплуатации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПроверитьЗаполнитьПартииТМЦВЭксплуатации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПроверитьЗаполнитьПартииТМЦВЭксплуатации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ПараметрыЗаполненияПартии = Новый Структура("Дата, Организация, Подразделение");
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполненияПартии, Объект);
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПартиюТМЦВЭксплуатации", ПараметрыЗаполненияПартии);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ПараметрыЗаполненияПартии = Новый Структура("Дата, Организация, Подразделение");
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполненияПартии, Объект);
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПартиюТМЦВЭксплуатации", ПараметрыЗаполненияПартии);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыФизическоеЛицоПриИзменении(Элемент)
	
	ПараметрыЗаполненияПартии = Новый Структура("Дата, Организация, Подразделение");
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполненияПартии, Объект);
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПартиюТМЦВЭксплуатации", ПараметрыЗаполненияПартии);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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


&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("Дата", Объект.Дата);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.ПартииТМЦВЭксплуатации.Форма.ФормаПодбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#Область СтандартныеПодсистемы_Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнитьПартииТМЦВЭксплуатации()
	
	ПараметрыЗаполненияПартии = Новый Структура("Дата, Организация, Подразделение");
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполненияПартии, Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПартиюТМЦВЭксплуатации", ПараметрыЗаполненияПартии);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.Товары, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти