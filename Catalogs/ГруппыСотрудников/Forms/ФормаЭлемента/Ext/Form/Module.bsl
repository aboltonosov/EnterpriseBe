﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		УстановитьОтображение();
		СсылкаНаОбъект = Справочники.ГруппыСотрудников.ПолучитьСсылку();
		
		Если ЗначениеЗаполнено(Объект.Родитель)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Родитель, "ФормироватьАвтоматически") Тогда
			
				Объект.Родитель = Справочники.ГруппыСотрудников.ПустаяСсылка();

		КонецЕсли; 
		
		Если Параметры.СозданиеГруппыСРучнымФормированием Тогда
			
			Объект.ФормироватьАвтоматически = Ложь;
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ФормироватьАвтоматически",
				"ТолькоПросмотр",
				Истина);
			
		КонецЕсли; 
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СоставГруппы, "ГруппаСотрудников", СсылкаНаОбъект, , , , РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СсылкаНаОбъект = ТекущийОбъект.Ссылка;
	НастройкиЗаполнения = ТекущийОбъект.ХранилищеНастроек.Получить();
	УстановитьОтображение();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ЭтоНовый() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНаОбъект);
	КонецЕсли; 
	ТекущийОбъект.ХранилищеНастроек = Новый ХранилищеЗначения(НастройкиЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ГруппыСотрудников", Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФормироватьАвтоматическиПриИзменении(Элемент)
	
	УстановитьОтображениеФормироватьАвтоматически(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСоставГруппы

&НаКлиенте
Процедура СоставГруппыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Если Не Копирование Тогда
		ВыполнитьПодборСотрудников(Ложь);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СоставГруппыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элементы.СоставГруппы.ТекущиеДанные.Сотрудник);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставГруппыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДобавитьСотрудников(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСоставАвтогруппы

&НаКлиенте
Процедура СоставАвтогруппыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элементы.СоставАвтогруппы.ТекущиеДанные.Сотрудник);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьКритерииОтбораСотрудников(Команда)
	
	НастроитьКритерииОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСоставСотрудниковГруппы(Команда)
	
	Если НастройкиЗаполнения = Неопределено Тогда
		
		Оповещение = Новый ОписаниеОповещения("ОбновитьСоставСотрудниковГруппыПредупреждениеЗавершение", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, НСтр("ru='Перед тем как сформировать список сотрудников необходимо настроить критерии отбора'"));
		
	Иначе
		ПоказатьСоставСотрудниковАвтогруппы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСотрудников(Команда)
	
	ВыполнитьПодборСотрудников(Истина);
	
КонецПроцедуры
	
#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСоставСотрудниковГруппыПредупреждениеЗавершение(Результат) Экспорт
	
	НастроитьКритерииОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьКритерииОтбора()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("КлючВарианта", "ЗаполнениеСписковСотрудников");
	ПараметрыОткрытия.Вставить("Вариант", НастройкиЗаполнения);
	
	Оповещение = Новый ОписаниеОповещения("НастроитьКритерииОтбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ГруппыСотрудников.Форма.ФормаНастройкиУсловийЗаполнения", ПараметрыОткрытия, ЭтаФорма, , , , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьКритерииОтбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если Результат.Свойство("НастройкиЗаполнения") Тогда
			НастройкиЗаполнения = Результат.НастройкиЗаполнения;
		КонецЕсли; 
		
		ПоказатьСоставСотрудниковАвтогруппы();
		Модифицированность = Истина;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСоставСотрудниковАвтогруппы()
	
	СоставАвтогруппы.Очистить();
	Если НастройкиЗаполнения <> Неопределено Тогда
		
		СотрудникиГруппы = ГруппыСотрудников.СотрудникиГруппыПоискаПоНастройкам(НастройкиЗаполнения);
		Для каждого СотрудникГруппы Из СотрудникиГруппы Цикл
			НоваяСтрокаСостава = СоставАвтогруппы.Добавить();
			НоваяСтрокаСостава.Сотрудник = СотрудникГруппы.Сотрудник;
		КонецЦикла;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбораСотрудников(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если Не ЗначениеЗаполнено(Объект.Ссылка) И Не Записать() Тогда
			Возврат;
		КонецЕсли; 
		
		Если ДополнительныеПараметры.Свойство("МножественныйВыбор") Тогда
			МножественныйВыбор = ДополнительныеПараметры.МножественныйВыбор;
		Иначе
			МножественныйВыбор = Ложь;
		КонецЕсли;
		
		КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДату(
			Элементы.СоставГруппы,
			,
			,
			ОбщегоНазначенияКлиент.ДатаСеанса(),
			МножественныйВыбор,
			АдресСпискаПодобранныхСотрудников());
			
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеФормироватьАвтоматически(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаОбновитьСоставСотрудниковГруппы",
		"Видимость",
		Форма.Объект.ФормироватьАвтоматически);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"НастроитьКритерииОтбораСотрудников",
		"Видимость",
		Форма.Объект.ФормироватьАвтоматически);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"СоставГруппыПодобратьСотрудников",
		"Видимость",
		Не Форма.Объект.ФормироватьАвтоматически);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"Родитель",
		"Видимость",
		Не Форма.Объект.ФормироватьАвтоматически);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"СоставГруппы",
		"Видимость",
		Не Форма.Объект.ФормироватьАвтоматически);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"СоставАвтоГруппы",
		"Видимость",
		Форма.Объект.ФормироватьАвтоматически);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображение()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Или Объект.ФормироватьАвтоматически Тогда
		ТолькоПросмотрФормироватьАвтоматически = Ложь; 
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Родитель", СсылкаНаОбъект);
		
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ГруппыСотрудников.Ссылка
			|ИЗ
			|	Справочник.ГруппыСотрудников КАК ГруппыСотрудников
			|ГДЕ
			|	ГруппыСотрудников.Родитель = &Родитель";
			
		ТолькоПросмотрФормироватьАвтоматически = Не Запрос.Выполнить().Пустой(); 
		
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормироватьАвтоматически",
		"ТолькоПросмотр",
		ТолькоПросмотрФормироватьАвтоматически);
	
	Если ТолькоПросмотрФормироватьАвтоматически Тогда
		
		ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
			ЭтаФорма, "ФормироватьАвтоматически", НСтр("ru='Для автоматического формирования состава сотрудников по параметрам, необходимо очистить состав подчиненных групп'"));
			
		ОтображениеПодсказкиЭлемента = ОтображениеПодсказки.ОтображатьСнизу;
		
	Иначе
		ОтображениеПодсказкиЭлемента = ОтображениеПодсказки.Авто;
	КонецЕсли; 
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормироватьАвтоматически",
		"ОтображениеПодсказки",
		ОтображениеПодсказкиЭлемента);
	
	УстановитьОтображениеФормироватьАвтоматически(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодборСотрудников(МножественныйВыбор)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("МножественныйВыбор", МножественныйВыбор);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Оповещение = Новый ОписаниеОповещения("ОткрытьФормуПодбораСотрудников", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Подобрать сотрудников можно будет только после записи данных.
			|Сохранить и продолжить?'");
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена)
		
	Иначе
		ОткрытьФормуПодбораСотрудников(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры
	
&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Набор = РегистрыСведений.СоставГруппСотрудников.СоздатьНаборЗаписей();
	Набор.Отбор.ГруппаСотрудников.Установить(Объект.Ссылка);
	
	Набор.Прочитать();
	СотрудникиНабора = Набор.ВыгрузитьКолонку("Сотрудник");
	
	Возврат ПоместитьВоВременноеХранилище(СотрудникиНабора, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ДобавитьСотрудников(ВыбранныеЗначения, Перезаполнить = Ложь)
	
	Если ТипЗнч(ВыбранныеЗначения) = Тип("СправочникСсылка.Сотрудники") Тогда
		Сотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранныеЗначения);
	Иначе
		Сотрудники = ВыбранныеЗначения;
	КонецЕсли;

	Набор = РегистрыСведений.СоставГруппСотрудников.СоздатьНаборЗаписей();
	Набор.Отбор.ГруппаСотрудников.Установить(Объект.Ссылка);
	
	Если Не Перезаполнить Тогда
		Набор.Прочитать();
		СотрудникиНабора = Набор.ВыгрузитьКолонку("Сотрудник");
	Иначе
		СотрудникиНабора = Неопределено;
	КонецЕсли;
	
	ЗаписатьНабор = Ложь;
	Для каждого Сотрудник Из Сотрудники Цикл
		
		Если Перезаполнить ИЛИ СотрудникиНабора.Найти(Сотрудник) = Неопределено Тогда
			
			ЗаписатьНабор = Истина;
			
			Запись = Набор.Добавить();
			Запись.ГруппаСотрудников = Объект.Ссылка;
			Запись.Сотрудник = Сотрудник;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Если ЗаписатьНабор Тогда
		
		Набор.Записать();
		Элементы.СоставГруппы.ТекущаяСтрока = Новый(Тип("РегистрСведенийКлючЗаписи.СоставГруппСотрудников"),
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый Структура("ГруппаСотрудников,Сотрудник", Запись.ГруппаСотрудников, Запись.Сотрудник)));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
