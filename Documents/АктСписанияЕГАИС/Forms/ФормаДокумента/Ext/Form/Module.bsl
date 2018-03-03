﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// МенюОтчеты
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьПодменюОтчеты(ЭтотОбъект);
	// Конец МенюОтчеты
	
	// ВводНаОсновании
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьПодменюСоздатьНаОсновании(ЭтотОбъект);
	// Конец ВводНаОсновании
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыХарактеристика");
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыУпаковка");
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	
	ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		ЭтотОбъект,
		ПоддерживаемыеТипыПодключаемогоОборудования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораПодборНоменклатуры(
		Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
		ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если НЕ РедактированиеФормыНедоступно Тогда
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияПодборНоменклатуры(
			Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
			ИмяСобытия, Параметр, Источник);
		
		СобытияФормЕГАИСКлиент.ОбработкаОповещенияПолученыШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ПолученыШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, ИмяСобытия, Параметр, Источник);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ОбработаныНеизвестныеШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Объект.ДокументОснование);
	Оповестить("Запись_АктСписанияЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если НЕ РедактированиеФормыНедоступно Тогда
		СобытияФормЕГАИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ПолученыШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Акт списания ЕГАИС был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Акт списания ЕГАИС не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияЕГАИСПриИзменении(Элемент)
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	ИдентификаторыСтрок = Новый Массив;
	ВыделенныеСтроки = Элементы.Товары.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		ИдентификаторыСтрок.Добавить(СтрокаТЧ.ИдентификаторСтроки);
	КонецЦикла;
	
	Если Не Отказ И ИдентификаторыСтрок.Количество() > 0 Тогда
		УдалитьАкцизныеМарки(ИдентификаторыСтрок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииХарактеристики(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииУпаковки(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСправка2АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Отбор.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСправка2ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.Справка2) Тогда
			ТекущиеДанные.АлкогольнаяПродукция = ИнтеграцияЕГАИСВызовСервера.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Справка2, "АлкогольнаяПродукция");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АкцизныеМарки(Команда)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторСтроки) Тогда
		ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	ДополнительныеПараметрыИзменениеАкцизныхМарок = Новый Структура;
	ДополнительныеПараметрыИзменениеАкцизныхМарок.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	ДополнительныеПараметрыИзменениеАкцизныхМарок.Вставить("Редактирование", Истина);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	ДополнительныеПараметры.Вставить("Редактирование", Истина);
	ДополнительныеПараметры.Вставить("АдресВоВременномХранилище", АдресТаблицыАкцизныхМаркиВоВременномХранилище(ТекущиеДанные.ИдентификаторСтроки));
	ДополнительныеПараметры.Вставить("Форма", ЭтотОбъект);
	ДополнительныеПараметры.Вставить(
		"ОповещениеПриЗавершении",
		Новый ОписаниеОповещения("ИзменениеАкцизныхМарокЗавершение", ЭтотОбъект, ДополнительныеПараметрыИзменениеАкцизныхМарок));
	
	АкцизныеМаркиЕГАИСКлиент.ОткрытьФормуСчитыванияАкцизнойМарки(
		Неопределено,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоОснованию(Команда)
	
	ОчиститьСообщения();
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Табличная часть будет перезаполнена. Продолжить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросОПерезаполнениииПоОснованиюПриЗавершении", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.АктСписанияЕГАИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, 
		"Документ.АктСписанияЕГАИС.ФормаДокумента.Команда.ОткрытьПодбор");
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуПодбораНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ОчиститьСообщения();
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыгрузитьДанныеВТСД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСправки2ПоОстаткамРегистра1(Команда)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.ОрганизацияЕГАИС) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Организация ЕГАИС""'"),
			Объект.Ссылка, "Объект.ОрганизацияЕГАИС");
		Возврат;
	КонецЕсли;
	
	СправкиЗаполнены = ПодобратьСправки2НаСервере();
	ИнтеграцияЕГАИСКлиент.СообщитьОЗавершенииЗаполненияСправок(СправкиЗаполнены);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если Не ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.АктСписанияЕГАИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.АктСписанияЕГАИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ОбновитьСтатусЕГАИС();
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

#Область АкцизныеМарки

&НаСервере
Функция АдресТаблицыАкцизныхМаркиВоВременномХранилище(ИдентификаторСтроки)
	
	Возврат АкцизныеМаркиЕГАИС.АдресТаблицыАкцизныхМаркиВоВременномХранилище(
		ЭтотОбъект,
		ИдентификаторСтроки);
	
КонецФункции

&НаСервере
Функция ЗагрузитьАкцизныеМаркиИзВременногоХранилища(ИдентификаторСтроки, АдресВоВременномХранилище)
	
	Возврат АкцизныеМаркиЕГАИС.ЗагрузитьАкцизныеМаркиИзВременногоХранилища(
		ЭтотОбъект,
		ИдентификаторСтроки,
		АдресВоВременномХранилище);
	
КонецФункции

&НаСервере
Функция ДанныеПоАкцизнымМаркам(ИдентификаторСтроки, КодАкцизнойМарки)
	
	Возврат АкцизныеМаркиЕГАИС.ДанныеПоАкцизнымМаркам(
		ЭтотОбъект,
		ИдентификаторСтроки,
		КодАкцизнойМарки);
	
КонецФункции

&НаСервере
Процедура УдалитьАкцизныеМарки(Данные)
	
	АкцизныеМаркиЕГАИС.УдалитьАкцизныеМарки(
		ЭтотОбъект,
		Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВводАкцизнойМаркиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуТабличнойЧасти = Ложь;
	Если ДополнительныеПараметры.Редактирование Тогда
		
		ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		ДанныеПоАкцизнымМаркам = ЗагрузитьАкцизныеМаркиИзВременногоХранилища(
			ТекущиеДанные.ИдентификаторСтроки,
			Результат);
		
	Иначе
		
		КодАкцизнойМарки           = Результат.КодАкцизнойМарки;
		СопоставленнаяНоменклатура = Результат.СопоставленнаяНоменклатура;
		ЗапрашиватьНоменклатуру    = ДополнительныеПараметры.ЗапрашиватьНоменклатуру;
		
		Если ДополнительныеПараметры.ИдентификаторСтроки = Неопределено Тогда
			ТекущиеДанные = Неопределено;
		Иначе
			НайденнаяСтрока = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
			Если  СопоставленнаяНоменклатура <> Неопределено
				И НайденнаяСтрока <> Неопределено
				И (НайденнаяСтрока.Номенклатура <> СопоставленнаяНоменклатура.Номенклатура
				   Или НайденнаяСтрока.Характеристика <> СопоставленнаяНоменклатура.Характеристика) Тогда
				ТекущиеДанные = Неопределено;
			Иначе
				ТекущиеДанные = НайденнаяСтрока;
			КонецЕсли;
		КонецЕсли;
		
		Если (СопоставленнаяНоменклатура <> Неопределено
			И ЗначениеЗаполнено(СопоставленнаяНоменклатура.Номенклатура))
			ИЛИ Не ЗапрашиватьНоменклатуру Тогда
			
			Если ТекущиеДанные <> Неопределено
				И Не ЗапрашиватьНоменклатуру Тогда
				
				// Добавление акцизной марки к текущий строке
				
			ИначеЕсли ТекущиеДанные <> Неопределено
				И СопоставленнаяНоменклатура.Номенклатура = ТекущиеДанные.Номенклатура
				И СопоставленнаяНоменклатура.Характеристика = ТекущиеДанные.Характеристика Тогда
				
				// Искомая алкогольная продукция найдена
				
			Иначе
				
				Если Объект.Товары.Количество() = 0 Тогда
					ТекущиеДанные = Объект.Товары.Добавить();
					ЗаполнитьЗначенияСвойств(ТекущиеДанные, СопоставленнаяНоменклатура);
					Если ЗначениеЗаполнено(СопоставленнаяНоменклатура.Номенклатура) Тогда
						ВыполнитьОбработкуТабличнойЧасти = Истина;
					Иначе
						ТекущиеДанные.АлкогольнаяПродукция = Истина;
						ТекущиеДанные.МаркируемаяАлкогольнаяПродукция = Истина;
					КонецЕсли;
				Иначе
					Если ТекущиеДанные = Неопределено Тогда
						ТекущиеДанные = Объект.Товары.Добавить();
						ЗаполнитьЗначенияСвойств(ТекущиеДанные, СопоставленнаяНоменклатура);
						Если ЗначениеЗаполнено(СопоставленнаяНоменклатура.Номенклатура) Тогда
							ВыполнитьОбработкуТабличнойЧасти = Истина;
						Иначе
							ТекущиеДанные.АлкогольнаяПродукция = Истина;
							ТекущиеДанные.МаркируемаяАлкогольнаяПродукция = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("КодАкцизнойМарки", КодАкцизнойМарки);
			Если СопоставленнаяНоменклатура <> Неопределено И ЗначениеЗаполнено(СопоставленнаяНоменклатура.НоменклатураЕГАИС) Тогда
				ПараметрыОткрытияФормы.Вставить("НоменклатураЕГАИС", СопоставленнаяНоменклатура.НоменклатураЕГАИС);
			КонецЕсли;
			
			ОткрытьФорму(
				"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
				ПараметрыОткрытияФормы,
				 ЭтотОбъект,,,,
				Новый ОписаниеОповещения("ВводАкцизнойМаркиЗавершение", ЭтотОбъект, ДополнительныеПараметры));
			Возврат;
			
		КонецЕсли;
		
		ДанныеПоАкцизнымМаркам = ДанныеПоАкцизнымМаркам(
			ТекущиеДанные.ИдентификаторСтроки,
			КодАкцизнойМарки);
		
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДополнительныеПараметры.Вставить("ВыполнитьОбработкуТабличнойЧасти", ВыполнитьОбработкуТабличнойЧасти);
	
	АкцизныеМаркиЕГАИСКлиент.ВводАкцизнойМаркиЗавершение(
		ДанныеПоАкцизнымМаркам,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеАкцизныхМарокЗавершение(ТекущаяСтрока, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	Если ДополнительныеПараметры.ВыполнитьОбработкуТабличнойЧасти Тогда
		ПараметрыЗаполнения.ПерезаполнитьНоменклатуруЕГАИС = Истина;
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииКоличества(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область Штрихкоды

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиент.ВыполнитьКомандуПоискПоШтрихкоду(
		Новый ОписаниеОповещения("Подключаемый_ПолученыШтрихкоды", ЭтотОбъект),
		ЭтотОбъект, ДанныеШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриПолученииДанныхИзТСД(
		Новый ОписаниеОповещения("Подключаемый_ПолученыДанныеИзТСД", ЭтотОбъект),
		ЭтотОбъект, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки       = Истина;
	ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ = ИспользоватьАкцизныеМарки;
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
		ЭтотОбъект, ДанныеШтрихкодов, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработаныНеизвестныеШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
	Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыДанныеИзТСД(ТаблицаТоваров, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки       = Истина;
	ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ = ИспользоватьАкцизныеМарки;
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьДанныеИзТСД(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьШтрихкоды(
		ЭтотОбъект, ДанныеДляОбработки, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеИзТСД(ТаблицаТоваров, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьДанныеИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область Подбор

&НаСервере
Процедура ОбработкаРезультатаПодбораНоменклатуры(ВыбранноеЗначение, ПараметрыЗаполнения)
	
	СобытияФормЕГАИСПереопределяемый.ОбработкаРезультатаПодбораНоменклатуры(
		ЭтотОбъект, ВыбранноеЗначение,
		ПараметрыЗаполнения);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаПодбораНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	ОбработкаРезультатаПодбораНоменклатуры(Результат, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область Статус

&НаСервере
Процедура ОбновитьСтатусЕГАИС()

	ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется;
	ЦветТекста         = Неопределено;
	
	Если Объект.СтатусОбработки = Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.Новый 
		Или Объект.СтатусОбработки = Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.ОшибкаПередачиВЕГАИС Тогда 
		
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные;
		
	ИначеЕсли Объект.СтатусОбработки = Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.ПереданВЕГАИС
		И Объект.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра1 Тогда
		
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтменуПроведения;
		
	КонецЕсли;
	
	Если Объект.СтатусОбработки = Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.ОшибкаПередачиВЕГАИС Тогда 
		
		ЦветТекста = ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи;
		
	КонецЕсли;
	
	ТекстПредставление = Новый ФорматированнаяСтрока(Строка(Объект.СтатусОбработки),,ЦветТекста);
	
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(ТекстПредставление, ДальнейшееДействие);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ПередатьДанные();
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЗапроситьОтменуПроведения" Тогда
		
		ЗапроситьОтменуПроведения();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные()
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(Объект.ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Объект.Ссылка;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ПослеПередачиДанныхЕГАИС", ЭтотОбъект),
		Объект.ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьОтменуПроведения()
	
	ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаСписания");
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Объект.Ссылка;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ПослеПередачиДанныхЕГАИС", ЭтотОбъект),
		ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементыФормы(Форма)
	
	ИспользуемыйФорматОбменаЕГАИС = ИнтеграцияЕГАИСВызовСервера.ФорматОбменаОрганизацииЕГАИС(Форма.Объект.ОрганизацияЕГАИС);
	
	АктСписанияИзРегистра1 = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктСписанияИзРегистра1");
	АктСписанияИзРегистра2 = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктСписанияИзРегистра2");
	НовыйАкт               = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиАктаСписанияЕГАИС.Новый");
	ОшибкаПередачиВЕГАИС   = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиАктаСписанияЕГАИС.ОшибкаПередачиВЕГАИС");
	Формат2                = ПредопределенноеЗначение("Перечисление.ФорматыОбменаЕГАИС.V2");
	
	Форма.ИспользоватьАкцизныеМарки = Форма.Объект.ВидДокумента = АктСписанияИзРегистра2
	                                  ИЛИ ИспользуемыйФорматОбменаЕГАИС = Формат2;
	
	Форма.РедактированиеФормыНедоступно = Форма.Объект.СтатусОбработки <> НовыйАкт
	                                      И Форма.Объект.СтатусОбработки <> ОшибкаПередачиВЕГАИС;
	
	Форма.Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = Форма.РедактированиеФормыНедоступно;
	Форма.Элементы.ГруппаНередактируемыеПослеОтправкиКомандыТовары.Доступность        = НЕ Форма.РедактированиеФормыНедоступно;
	Форма.Элементы.СтраницаТовары.ТолькоПросмотр                                      = Форма.РедактированиеФормыНедоступно;
	
	Форма.Элементы.ТоварыПерезаполнитьПоОснованию.Видимость = ЗначениеЗаполнено(Форма.Объект.ДокументОснование);
	
	Форма.Элементы.ТоварыСправка2.Видимость          = (Форма.Объект.ВидДокумента = АктСписанияИзРегистра1);
	Форма.Элементы.ТоварыПодобратьСправки2.Видимость = (Форма.Объект.ВидДокумента = АктСписанияИзРегистра1);
	
	Форма.Элементы.ТоварыАкцизныеМарки.Видимость       = Форма.ИспользоватьАкцизныеМарки;
	Форма.Элементы.ТоварыИндексАкцизнойМарки.Видимость = Форма.ИспользоватьАкцизныеМарки;
	
	ОбновитьСписокПричинСписания(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСписокПричинСписания(Форма)
	
	СписокПричинСписания = Форма.Элементы.ПричинаСписания.СписокВыбора;
	
	ПричинаИныеЦели = ПредопределенноеЗначение("Перечисление.ПричиныСписанийЕГАИС.ИныеЦели");
	ПричинаРеализация = ПредопределенноеЗначение("Перечисление.ПричиныСписанийЕГАИС.Реализация");
	
	ЭлементСпискаИныеЦели = СписокПричинСписания.НайтиПоЗначению(ПричинаИныеЦели);
	ЭлементСпискаРеализация = СписокПричинСписания.НайтиПоЗначению(ПричинаРеализация);
	
	Если Форма.ИспользоватьАкцизныеМарки Тогда
		Если ЭлементСпискаИныеЦели = Неопределено Тогда
			СписокПричинСписания.Добавить(ПричинаИныеЦели);
		КонецЕсли;
		Если ЭлементСпискаРеализация = Неопределено Тогда
			СписокПричинСписания.Добавить(ПричинаРеализация);
		КонецЕсли;
	Иначе
		Если ЭлементСпискаИныеЦели <> Неопределено Тогда
			СписокПричинСписания.Удалить(ЭлементСпискаИныеЦели);
		КонецЕсли;
		Если ЭлементСпискаРеализация <> Неопределено Тогда
			СписокПричинСписания.Удалить(ЭлементСпискаРеализация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Оборудование

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПерезаполнитьПоОснованиюСервер()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Объект.ДокументОснование);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПерезаполнениииПоОснованиюПриЗавершении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодобратьСправки2НаСервере()
	
	СправкиЗаполнены = Документы.АктСписанияЕГАИС.ПодобратьСправки2(Объект);
	
	Возврат СправкиЗаполнены;
	
КонецФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура ПослеПередачиДанныхЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	Прочитать();
	
	ИнтеграцияЕГАИСКлиент.ПослеПередачиДанныхЕГАИС(Результат, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти