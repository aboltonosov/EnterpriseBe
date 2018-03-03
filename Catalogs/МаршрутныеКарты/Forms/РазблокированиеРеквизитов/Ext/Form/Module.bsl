﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УстановитьЗаголовкиДекораций();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Закрыть(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИспользованиеОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовУТКлиент.ПроверитьИспользованиеОбъекта(
		ЭтаФорма,
		ПараметрыОбработчикаОжидания,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьЗаголовкиДекораций()
	
	ИспользуетсяПроизводство21 = УправлениеПроизводством.ИспользуетсяПроизводство21();
	ИспользуетсяПроизводство22 = УправлениеПроизводством.ИспользуетсяПроизводство22();
	
	// ПояснениеИзделияМатериалыТрудозатраты
	Если ИспользуетсяПроизводство22 И ИспользуетсяПроизводство21 Тогда
		ТекстЗаголовка = НСтр("ru = 'Ресурсные спецификации, маршрутные листы и этапы производства станут некорректными.'");
	ИначеЕсли ИспользуетсяПроизводство22 Тогда
		ТекстЗаголовка = НСтр("ru = 'Ресурсные спецификации и этапы производства станут некорректными.'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Ресурсные спецификации и маршрутные листы станут некорректными.'");
	КонецЕсли;
	Элементы.ПояснениеИзделияМатериалыТрудозатраты.Заголовок = ТекстЗаголовка;
	
	// ПояснениеОперации
	Если ИспользуетсяПроизводство22 И ИспользуетсяПроизводство21 Тогда
		ТекстЗаголовка = НСтр("ru = 'Маршрутные листы и этапы производства станут некорректными.'");
	ИначеЕсли ИспользуетсяПроизводство22 Тогда
		ТекстЗаголовка = НСтр("ru = 'Этапы производства станут некорректными.'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Маршрутные листы станут некорректными.'");
	КонецЕсли;
	Элементы.ПояснениеОперации.Заголовок = ТекстЗаголовка;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	ЗапретРедактированияРеквизитовОбъектовУТКлиент.ПроверитьВыполнениеЗадания(
		ЭтаФорма,
		ФормаДлительнойОперации,
		ПараметрыОбработчикаОжидания);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
