﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ID = Параметры.ID;
	Тип = Параметры.type;
	Если НЕ ЗначениеЗаполнено(Тип) Тогда
		Тип = "DMDailyReport";
	КонецЕсли;
	
	ЗначениеПеречисленияДлительность = "Длительность";
	ЗначениеПеречисленияВремяНачала  = "ВремяНачала";
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Если ЗначениеЗаполнено(ID) И ЗначениеЗаполнено(Тип) Тогда 
		Ответ = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси, Параметры.type, Параметры.id, новый Массив);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
		ОбъектXDTO = Ответ.objects[0];
	Иначе
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetNewObjectRequest");
		Запрос.type = Тип;
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		ОбъектXDTO = Результат;
		Модифицированность = Истина;
	КонецЕсли;
	
	ЗаполнитьФормуОбъекта(ОбъектXDTO);
	
	// установка видимости полей
	УстановитьВидимость();
	
	Если Свойства.Количество() > 0 Тогда 
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;
	
	// хронометраж
	Если Не ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP") Тогда
		Элементы.РаботыПроектЗадача.Видимость = Ложь;
		Элементы.РаботыОкончание.Видимость = Ложь;
	Иначе 
		ДоступенФункционалХронометраж = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РассчитатьПродолжительностьДня(); 
	ОбновитьПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗакрытиеСПараметром Тогда 
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтаФорма);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
		
	Иначе
		
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ЗакрытьСПараметром", 0.1, Истина);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Документооборот_ВыбратьЗначениеИзСпискаВТаблицеЗавершение" И Источник = ЭтаФорма Тогда
		Если Параметр.Реквизит = "Проект" Тогда
			Параметр.Данные.ПроектнаяЗадача = "";
			Параметр.Данные.ПроектнаяЗадачаID = "";
			Параметр.Данные.ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(
					Параметр.Данные.Проект, Параметр.Данные.ПроектнаяЗадача);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПриИзмененииДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоДняПриИзменении(Элемент)
	
	НачалоДня = НачалоДня - Секунда(НачалоДня);
	
	Если НачалоДня > ОкончаниеДня И ЗначениеЗаполнено(ОкончаниеДня) Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Указанное время начала дня больше времени окончания!'"));
	КонецЕсли;
	
	РассчитатьПродолжительностьДня();
	ОбновитьПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеДняПриИзменении(Элемент)
	
	ОкончаниеДня = ОкончаниеДня - Секунда(ОкончаниеДня);
	
	Если ОкончаниеДня < НачалоДня И ЗначениеЗаполнено(ОкончаниеДня) Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Указанное время окончания дня меньше времени начала'"));	
	КонецЕсли;
	
	Если (СпособУказанияВремениID = ЗначениеПеречисленияВремяНачала) И (Работы.Количество() > 0) И ЗначениеЗаполнено(ОкончаниеДня) Тогда 
		Если ОкончаниеДня < Работы[Работы.Количество()-1].Начало Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Указанное время окончания дня меньше времени начала одной из работ!'"));
			ОкончаниеДня = '00010101';
		КонецЕсли;
	КонецЕсли;
	
	РассчитатьДлительностьСтрок();
	РассчитатьПродолжительностьДня();
	ОбновитьПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Пользователь", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		 Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Пользователь", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Пользователь", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СвойстваЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеДополнительногоРеквизита(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРаботы

&НаКлиенте
Процедура РаботыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда 
		
		ТекущиеДанные = Элементы.Работы.ТекущиеДанные; 
		Если Не Копирование Тогда 
			ТекущиеДанные.ВидРабот = ОсновнойВидРабот;
			ТекущиеДанные.ВидРаботID = ОсновнойВидРаботID;
			ТекущиеДанные.ВидРаботТип = ОсновнойВидРаботТип;
			ТекущиеДанные.Проект = ОсновнойПроект;
			ТекущиеДанные.ПроектID = ОсновнойПроектID;
			ТекущиеДанные.ПроектТип = ОсновнойПроектТип;
			
			ТекущиеДанные.ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(
				ТекущиеДанные.Проект,ТекущиеДанные.ПроектнаяЗадача);
				
			ЗаполнитьСписокТиповИсточника(ТекущиеДанные.ИсточникСписокТипов);
			
		КонецЕсли;
			
		ТекущиеДанные.ДатаДобавления = ТекущаяДата(); // Использование оправдано: фиксируется дата-время на клиенте.
		
		Если СпособУказанияВремениID = ЗначениеПеречисленияВремяНачала Тогда 
			Если ДоступенФункционалХронометраж Тогда
				Строка = Работы.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
				Индекс = Работы.Индекс(Строка);
				Если Индекс > 0 Тогда 
					ТекущиеДанные.Начало = Работы[Индекс-1].Окончание;
				Иначе
					ТекущиеДанные.Начало = НачалоДня;
				КонецЕсли;
			Иначе
				ТекущаяДата = ТекущаяДата(); // Использование оправдано: фиксируется дата-время на клиенте.
				ТекущиеДанные.Начало = ТекущаяДата - Секунда(ТекущаяДата);
			КонецЕсли;
			
			РассчитатьДлительностьСтрок();
			ПересчитатьНачалоДня();
			
		КонецЕсли;
		
		ОбновитьПодвал();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьДлительностьСтрок();
	ОбновитьПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыПослеУдаления(Элемент)
	
	РассчитатьДлительностьСтрок();
	ОбновитьПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыНачалоПриИзменении(Элемент)
	
	Если Не ДоступенФункционалХронометраж Тогда
		ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
		#Если ВебКлиент Тогда
			ТекущиеДанные.Начало = ТекущиеДанные.Начало - Секунда(ТекущиеДанные.Начало);
		#КонецЕсли
		
		РассчитатьДлительностьСтрок();
		ПересчитатьНачалоДня();
		ОбновитьПодвал();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыДлительностьСтрПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	
	Если Не ИнтеграцияС1СДокументооборотКлиентСервер.ПроверитьФормат(ТекущиеДанные.ДлительностьСтр) Тогда
		ТекущиеДанные.ДлительностьСтр = "";
	КонецЕсли;
	ТекущиеДанные.Длительность = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоИзСтроки(ТекущиеДанные.ДлительностьСтр);
	
	ОбновитьПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыВидРаботПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	Если ПустаяСтрока(ТекущиеДанные.ВидРабот) Тогда
		ТекущиеДанные.ВидРаботID = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыВидРаботНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзСпискаВТаблице(
		"DMWorkType", "ВидРабот", ТекущиеДанные, ЭтаФорма);
			
КонецПроцедуры

&НаКлиенте
Процедура РаботыВидРаботАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMWorkType", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыВидРаботОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMWorkType", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ВидРабот", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма, Истина, Элемент);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
		
		Элементы.Работы.ТекущиеДанные.ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(
			Элементы.Работы.ТекущиеДанные.Проект, Элементы.Работы.ТекущиеДанные.ПроектнаяЗадача);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыВидРаботОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ВидРабот", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма, Истина, Элемент);
		
КонецПроцедуры

&НаКлиенте
Процедура РаботыПроектЗадачаПриИзменении(Элемент)
	
	Строка = Элементы.Работы.ТекущиеДанные;
	
	Если Строка.ПроектЗадача = "" Тогда
		Строка.Проект = "";
		Строка.ПроектID = "";
		Строка.ПроектнаяЗадача = "";
		Строка.ПроектнаяЗадачаID = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыПроектЗадачаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзСпискаВТаблице("DMProject", "Проект", ТекущиеДанные, ЭтаФорма);
	
	ТекущиеДанные.ПроектнаяЗадача = "";
	ТекущиеДанные.ПроектнаяЗадачаID = "";
	ТекущиеДанные.ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(
			ТекущиеДанные.Проект, ТекущиеДанные.ПроектнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыПроектЗадачаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMProject", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Проект", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма, Истина, Элемент);
				
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыПроектЗадачаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMProject", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Проект", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма, Истина, Элемент);
				
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыПроектЗадачаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Проект", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма, Истина, Элемент);
		
	Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение.type = "DMProject" Тогда
		Элемент.Родитель.ТекущиеДанные.ПроектнаяЗадача = "";
		Элемент.Родитель.ТекущиеДанные.ПроектнаяЗадачаID = "";
	КонецЕсли;
	
	Строка = Элементы.Работы.ТекущиеДанные;
	Строка.ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(Строка.Проект, Строка.ПроектнаяЗадача);
		
КонецПроцедуры

&НаКлиенте
Процедура РаботыИсточникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеРеквизитаСоставногоТипаВТаблице(
		ЭтаФорма, Элементы.Работы.ТекущиеДанные, "Источник", СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Отказ = Ложь;
	ОбработкаПроверкиЗаполнения(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьОбъект();
	Модифицированность = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтаФорма);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Отказ = Ложь;
	ОбработкаПроверкиЗаполнения(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьОбъект();
	Модифицированность = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаписатьОбъект();
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтаФорма);
	ЗакрытьСПараметром();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииДаты()
	
	Если Не ЗначениеЗаполнено(ID) И ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP") Тогда
		
		Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
		
		СписокУсловий = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
		
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "beginDate";
		Условие.value = НачалоДня(Дата);
		СписокУсловий.conditions.Добавить(Условие);
		
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "endDate";
		Условие.value = КонецДня(Дата);
		СписокУсловий.conditions.Добавить(Условие);
		
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "byUser";
		Условие.value = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ПользовательID, ПользовательТип);
		СписокУсловий.conditions.Добавить(Условие);
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
		Запрос.type = "DMActualWork";
		Запрос.query = СписокУсловий;
		
		Ответ = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
		Работы.Очистить();
		
		Для Каждого СтрокаОтвета Из Ответ.items Цикл
			
			Строка = СтрокаОтвета.object;
			
			НоваяСтрока = Работы.Добавить();
			НоваяСтрока.ДатаДобавления = Строка.addDate;
			НоваяСтрока.Начало = Строка.begin;
			НоваяСтрока.Окончание = Строка.end;
			НоваяСтрока.Работа = Строка.description;
			НоваяСтрока.Длительность = Строка.duration;
			НоваяСтрока.ДлительностьСтр = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(НоваяСтрока.Длительность);
			
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.workType, "ВидРабот", Ложь);
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.project,"Проект", Ложь);
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.projectTask,"ПроектнаяЗадача", Ложь);
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.source, "Источник", Ложь);
			
			НоваяСтрока.ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(
				НоваяСтрока.Проект, НоваяСтрока.ПроектнаяЗадача);
			
			Для Каждого ОписаниеТипа Из Строка.sourceValueTypes Цикл
				ДанныеОТипе = Новый Структура("xdtoClassName, presentation");
				ДанныеОТипе.xdtoClassName = ОписаниеТипа.xdtoClassName;
				ДанныеОТипе.presentation = ОписаниеТипа.presentation;
				НоваяСтрока.ИсточникСписокТипов.Добавить(ДанныеОТипе, ОписаниеТипа.presentation);
			КонецЦикла;
			
			НоваяСтрока.ИсточникСписокТипов.СортироватьПоПредставлению();
			
		КонецЦикла;
		
	КонецЕсли;
		
	СформироватьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗаполнитьСписокТиповИсточника(СписокТипов) 
	
	СписокТипов.Очистить();
	
	ТипыИсточника = Новый Структура;
	ТипыИсточника.Вставить("DMInternalDocument",НСтр("ru='Внутренний документ'"));
	ТипыИсточника.Вставить("DMIncomingEMail", НСтр("ru='Входящее письмо'"));
	ТипыИсточника.Вставить("DMIncomingDocument", НСтр("ru='Входящий документ'"));
	ТипыИсточника.Вставить("DMDailyReport", НСтр("ru='Ежедневный отчет'"));
	ТипыИсточника.Вставить("DMBusinessProcessTask", НСтр("ru='Задача'"));
	ТипыИсточника.Вставить("DMOutgoingEMail", НСтр("ru='Исходящее письмо'"));
	ТипыИсточника.Вставить("DMOutgoingDocument", НСтр("ru='Исходящий документ'"));
	ТипыИсточника.Вставить("DMActivity", НСтр("ru='Мероприятие'"));
	ТипыИсточника.Вставить("DMProject", НСтр("ru='Проект'"));
	ТипыИсточника.Вставить("DMProjectTask", НСтр("ru='Проектная задача'"));
	ТипыИсточника.Вставить("DMFile", НСтр("ru='Файл'"));
	
	Для Каждого ТипИсточника Из ТипыИсточника Цикл
		СписокТипов.Добавить(Новый Структура("xdtoClassName, presentation",ТипИсточника.Ключ, ТипИсточника.Значение), ТипИсточника.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуОбъекта(ОбъектXDTO)
	
	ID = ОбъектXDTO.objectID.id;
	Тип =  ОбъектXDTO.objectID.type;
	
	Представление = ОбъектXDTO.objectID.presentation;
	Заголовок = ОбъектXDTO.objectID.presentation;
	Номер = ОбъектXDTO.number;
	Дата = ОбъектXDTO.date;
	НачалоДня = ОбъектXDTO.dayBegin;
	ОкончаниеДня = ОбъектXDTO.dayEnd;
	НекорректнаяДлительность = ОбъектXDTO.durationIncorrect;
	ВестиУчетПоПроектам = ОбъектXDTO.projectsEnabled;
	
	СформироватьЗаголовокФормы();
	
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.user, "Пользователь", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.author, "Автор", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.timeInputMethod,"СпособУказанияВремени", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.mainProject,"ОсновнойПроект", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.mainWorkType,"ОсновнойВидРабот", Ложь);
	
	Работы.Очистить();
	
	Для Каждого Строка Из ОбъектXDTO.works Цикл
		НоваяСтрока = Работы.Добавить();
		НоваяСтрока.ДатаДобавления = Строка.addDate;
		НоваяСтрока.Начало = Строка.begin;
		НоваяСтрока.Окончание = Строка.end;
		НоваяСтрока.Работа = Строка.description;
		НоваяСтрока.Длительность = Строка.duration;
		НоваяСтрока.ДлительностьСтр = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(НоваяСтрока.Длительность);
		
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.workType, "ВидРабот", Ложь);
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.project,"Проект", Ложь);
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.projectTask,"ПроектнаяЗадача", Ложь);
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.source, "Источник", Ложь);
		
		НоваяСтрока.ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(
			НоваяСтрока.Проект, НоваяСтрока.ПроектнаяЗадача);
		
		Для Каждого ОписаниеТипа Из Строка.sourceValueTypes Цикл
			ДанныеОТипе = Новый Структура("xdtoClassName, presentation");
			ДанныеОТипе.xdtoClassName = ОписаниеТипа.xdtoClassName;
			ДанныеОТипе.presentation = ОписаниеТипа.presentation;
			НоваяСтрока.ИсточникСписокТипов.Добавить(ДанныеОТипе, ОписаниеТипа.presentation);
		КонецЦикла;
		
		НоваяСтрока.ИсточникСписокТипов.СортироватьПоПредставлению();
		
	КонецЦикла;
	
	Если СпособУказанияВремениID = ЗначениеПеречисленияВремяНачала Тогда 
		Работы.Сортировать("Начало");
	Иначе
		Работы.Сортировать("ДатаДобавления");
	КонецЕсли;	
	
	Обработки.ИнтеграцияС1СДокументооборот.ПоместитьДополнительныеРеквизитыНаФорму(ЭтаФорма, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьНавигационнуюСсылку(ЭтаФорма, ОбъектXDTO);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьДлительностьСтрок()
	
	// заполнение поля длительность
	Если (СпособУказанияВремениID = ЗначениеПеречисленияВремяНачала) И (Работы.Количество() > 0) Тогда
		Работы.Сортировать("Начало Возр");

		Если ДоступенФункционалХронометраж Тогда
			Для Каждого Строка Из Работы Цикл
				Если Строка.Окончание > Строка.Начало Тогда 
					Строка.Длительность = Строка.Окончание - Строка.Начало;
				Иначе
					Строка.Длительность = 0;
				КонецЕсли;	
			КонецЦикла;
		Иначе
			Для Инд = 0 По Работы.Количество() - 2 Цикл
				Работы[Инд].Длительность = Работы[Инд+1].Начало - Работы[Инд].Начало;
			КонецЦикла;
			
			Инд = Работы.Количество() - 1;
			Если ЗначениеЗаполнено(ОкончаниеДня) Тогда // последняя строка
				Если Работы[Инд].Начало <= ОкончаниеДня Тогда
					Работы[Инд].Длительность = ОкончаниеДня - Работы[Инд].Начало;
				КонецЕсли;
			Иначе
				Работы[Инд].Длительность = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьПродолжительностьДня()
	
	Если Не ЗначениеЗаполнено(НачалоДня) Или Не ЗначениеЗаполнено(ОкончаниеДня) Тогда 
		ПродолжительностьДня = "";
		
	ИначеЕсли НачалоДня > ОкончаниеДня Тогда 
		ПродолжительностьДня = "";
		
	Иначе
		ПродолжительностьДня = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(ОкончаниеДня - НачалоДня);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокФормы()
	
    Если Не ЗначениеЗаполнено(ID) Тогда
		ЭтаФорма.Заголовок = НСтр("ru = 'Ежедневный отчет (создание)'");
	Иначе
		ЭтаФорма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ежедневный отчет за %1'"), Формат(Дата, "ДЛФ=D"));
	КонецЕсли;
	
	Элементы.НачалоДня.Заголовок = ТРег(Формат(Дата, "ДФ=дддд"));

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПодвал()
	
	// вывод строки Всего за день
	ДлительностьРаботСек = 0;
	Для Каждого Строка Из Работы Цикл
		ДлительностьРаботСек = ДлительностьРаботСек + Строка.Длительность;
	КонецЦикла;
	ДлительностьРабот = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Всего за день: %1'"), ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(ДлительностьРаботСек, "0"));
	
	// вывод строки Превышено \ Осталось
	ПродолжительностьДняСек = ОкончаниеДня - НачалоДня;
	
	Если Не ЗначениеЗаполнено(НачалоДня) Или Не ЗначениеЗаполнено(ОкончаниеДня) Тогда 
		СообщениеОшибки = "";
		
	ИначеЕсли ДлительностьРаботСек > ПродолжительностьДняСек Тогда 
		СообщениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '(превышено на %1)'"),
			ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(ДлительностьРаботСек - ПродолжительностьДняСек));
		
	ИначеЕсли ДлительностьРаботСек < ПродолжительностьДняСек Тогда 
		СообщениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '(осталось %1)'"),
			ИнтеграцияС1СДокументооборотКлиентСервер.ЧисловСтроку(ПродолжительностьДняСек - ДлительностьРаботСек));
		
	Иначе
		СообщениеОшибки = "";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Если СпособУказанияВремениID = ЗначениеПеречисленияДлительность Тогда
		
		Элементы.РаботыНачало.Видимость = Ложь;
		Элементы.РаботыОкончание.Видимость = Ложь;
		Элементы.РаботыДлительностьСтр.Видимость = Истина;
		
	ИначеЕсли СпособУказанияВремениID = ЗначениеПеречисленияВремяНачала Тогда
		
		Элементы.РаботыНачало.Видимость = Истина;
		Элементы.РаботыОкончание.Видимость = Истина;
		Элементы.РаботыДлительностьСтр.Видимость = Ложь;
		
	КонецЕсли;
	
	Если ВестиУчетПоПроектам Тогда
		
		Элементы.РаботыПроектЗадача.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПроверкиЗаполнения(Отказ)
	
	Для Каждого Строка Из Работы Цикл
		ИндексСтроки = Работы.Индекс(Строка);
		
		Если Не ЗначениеЗаполнено(Строка.Работа) Тогда 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполнена колонка ""Содержание работ"" в строке %1 списка ""Работы"".'"),
				ИндексСтроки+1);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, 
				"Работы["+ Формат(ИндексСтроки, "ЧН=0; ЧГ=0") +"].Работа",,Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.ВидРабот) Тогда 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполнена колонка ""Вид работ"" в строке %1 списка ""Работы"".'"),
				ИндексСтроки+1);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, 
				"Работы["+ Формат(ИндексСтроки, "ЧН=0; ЧГ=0") +"].ВидРабот",,Отказ);
		КонецЕсли;
		
		Если СпособУказанияВремениID = ЗначениеПеречисленияДлительность Тогда
			Длительность = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоИзСтроки(Строка.ДлительностьСтр);
			Если Не ЗначениеЗаполнено(Длительность) Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Время"" в строке %1 списка ""Работы"".'"),
					ИндексСтроки+1);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, 
					"Работы["+ Формат(ИндексСтроки, "ЧН=0; ЧГ=0") +"].ДлительностьСтр",,Отказ);
			КонецЕсли;	
		Иначе
			Если Не ЗначениеЗаполнено(Строка.Начало) Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Начало работ"" в строке %1 списка ""Работы"".'"),
					ИндексСтроки+1);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, 
					"Работы["+ Формат(ИндексСтроки, "ЧН=0; ЧГ=0") +"].Начало",,Отказ);
			КонецЕсли;	
			
			Если ДоступенФункционалХронометраж Тогда
				Если Не ЗначениеЗаполнено(Строка.Окончание) Тогда 
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не заполнена колонка ""Окончание работ"" в строке %1 списка ""Работы"".'"),
						ИндексСтроки+1);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, 
						"Работы["+ Формат(ИндексСтроки, "ЧН=0; ЧГ=0") +"].Окончание",,Отказ);
				КонецЕсли;	
					
				Если Строка.Начало > Строка.Окончание Тогда 
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Время начала работ больше, чем время окончания работ в строке %1 списка ""Работы"".'"),
						ИндексСтроки+1);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, 
						"Работы["+ Формат(ИндексСтроки, "ЧН=0; ЧГ=0") +"].Начало",,Отказ);
				КонецЕсли;	
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Если ДоступенФункционалХронометраж Тогда
		
		Если СпособУказанияВремениID = ЗначениеПеречисленияВремяНачала Тогда
			
			// Проверка пересекающихся интервалов
			Для Инд1 = 0 По Работы.Количество()-2 Цикл
				Строка1 = Работы[Инд1];
				
				Для Инд2 = Инд1+1 По Работы.Количество()-1 Цикл
					Строка2 = Работы[Инд2];
					
					Если (Строка2.Начало >= Строка1.Начало И Строка2.Начало < Строка1.Окончание)
						Или (Строка2.Окончание > Строка1.Начало И Строка2.Окончание <= Строка1.Окончание) Тогда 
						
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Найдены пересекающиеся интервалы времени в строках %1 и %2 списка ""Работы"".'"),
							Инд1+1,
							Инд2+1);
						
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, 
							"Работы",,Отказ);
					КонецЕсли;	
				КонецЦикла;
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОбъект()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, Тип);
	
	Обработки.ИнтеграцияС1СДокументооборот.СформироватьДополнительныеСвойства(Прокси, ОбъектXDTO, ЭтаФорма);
	
	СоответствиеРеквизитов = НовыйСоответствиеСвойствXDTOИРеквизитовОбъекта();
	
	Для Каждого СтрокаСоответствия Из СоответствиеРеквизитов Цикл
		Если ТипЗнч(СтрокаСоответствия.Значение) = Тип("Строка") Тогда
			ИнтеграцияС1СДокументооборот.ЗаполнитьСвойствоXDTOизСтруктурыРеквизитов(
				Прокси,
				ОбъектXDTO,
				СтрокаСоответствия.Значение,
				ЭтаФорма,
				СтрокаСоответствия.Ключ);
		Иначе
			Для Каждого Строка Из ЭтаФорма[СтрокаСоответствия.Ключ] Цикл
				СтрокаXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, СтрокаСоответствия.Значение.Тип);
				Для Каждого СтрокаСоответствияТЧ Из СтрокаСоответствия.Значение.Реквизиты Цикл
					ИнтеграцияС1СДокументооборот.ЗаполнитьСвойствоXDTOизСтруктурыРеквизитов(
						Прокси,
						СтрокаXDTO,
						СтрокаСоответствияТЧ.Значение,
						Строка,
						СтрокаСоответствияТЧ.Ключ);
				КонецЦикла;
				ОбъектXDTO[СтрокаСоответствия.Значение.Имя].Добавить(СтрокаXDTO);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ID) И ЗначениеЗаполнено(Тип) Тогда // обновление
		
		ОбъектXDTO.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ID, Тип);
		ОбъектXDTO.name = Представление;
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMUpdateRequest");
		Запрос.objects.Добавить(ОбъектXDTO);
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат.objects[0];
	
	Иначе // создание
		
		ОбъектXDTO.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, "", "");
		ОбъектXDTO.name = Представление;
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMCreateRequest");
		Запрос.object = ОбъектXDTO;
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат.object;
		ID  = ОбъектXDTO.objectId.id;
		Тип = ОбъектXDTO.objectId.type;
		
	КонецЕсли;
	
	// перечитать объект в форму
	ЗаполнитьФормуОбъекта(ОбъектXDTO);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСПараметром()
	
	Результат = Новый Структура;
	Результат.Вставить("id", ID);
	Результат.Вставить("type", Тип);
	Результат.Вставить("name", Представление);
	
	ЗакрытиеСПараметром = Истина;
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьНачалоДня()
	
	Если Не ДоступенФункционалХронометраж Тогда
			
		Если СпособУказанияВремениID = ЗначениеПеречисленияВремяНачала Тогда
			
			ТекНачалоДня = '99990101';
			Для Каждого Строка Из Работы Цикл
				Если ТекНачалоДня > Строка.Начало И ЗначениеЗаполнено(Строка.Начало) Тогда 
					ТекНачалоДня = Строка.Начало;
				КонецЕсли;	
			КонецЦикла;	
			
			Если ТекНачалоДня = '99990101' Тогда 
				НачалоДня = '00010101';
			Иначе
				НачалоДня = ТекНачалоДня;
			КонецЕсли;
			РассчитатьПродолжительностьДня();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Функция НовыйСоответствиеСвойствXDTOИРеквизитовОбъекта()
	
	СоответствиеРеквизитов = Новый Соответствие;
	СоответствиеРеквизитов.Вставить("Дата", "date");
	СоответствиеРеквизитов.Вставить("НачалоДня", "dayBegin");
	СоответствиеРеквизитов.Вставить("ОкончаниеДня", "dayEnd");
	СоответствиеРеквизитов.Вставить("ПродолжительностьДня", "duration");
	СоответствиеРеквизитов.Вставить("НекорректнаяДлительность", "durationIncorrect");
	СоответствиеРеквизитов.Вставить("Автор", "author");
	СоответствиеРеквизитов.Вставить("Пользователь", "user");
	СоответствиеРеквизитов.Вставить("СпособУказанияВремени", "timeInputMethod");
	
	СоответствиеРеквизитовТЧ = Новый Соответствие;
	СоответствиеРеквизитовТЧ.Вставить("ДатаДобавления", "addDate");
	СоответствиеРеквизитовТЧ.Вставить("Начало", "begin");
	СоответствиеРеквизитовТЧ.Вставить("Окончание", "end");
	СоответствиеРеквизитовТЧ.Вставить("Работа", "description");
	СоответствиеРеквизитовТЧ.Вставить("Длительность", "duration");
	СоответствиеРеквизитовТЧ.Вставить("ВидРабот", "workType");
	СоответствиеРеквизитовТЧ.Вставить("Проект", "project");
	СоответствиеРеквизитовТЧ.Вставить("ПроектнаяЗадача", "projectTask");
	СоответствиеРеквизитовТЧ.Вставить("Источник", "source");
	
	СтруктураТЧ = Новый Структура;
	СтруктураТЧ.Вставить("Имя", "works");
	СтруктураТЧ.Вставить("Тип", "DMActualWork");
	СтруктураТЧ.Вставить("Реквизиты", СоответствиеРеквизитовТЧ);
	
	СоответствиеРеквизитов.Вставить("Работы", СтруктураТЧ);
	
	Возврат СоответствиеРеквизитов;
	
КонецФункции

#КонецОбласти
