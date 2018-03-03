﻿&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаОбъектов = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
	
	РежимВыбора = Параметры.Свойство("РежимВыбора", РежимВыбора);
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "ОбъектКалькуляции, Документ, Действие");
	
	Если РежимВыбора Тогда
		
		Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
		ТолькоПросмотр = Истина;
		Элементы.Выбрать.КнопкаПоУмолчанию = Истина;
		Заголовок = НСтр("ru = 'Позиции заказов на производство плановой калькуляции'");
		Для Каждого Строка Из ТаблицаОбъектов Цикл
			ЗаполнитьЗначенияСвойств(СписокЗаказовНаПроизводство.Добавить(), Строка);
		КонецЦикла;
		Элементы.СтраницыОбъектыКалькуляции.ТекущаяСтраница = Элементы.СтраницыОбъектыКалькуляции.ПодчиненныеЭлементы.СтраницаВыборПозиции;
		ОбновитьПредставленияНаСервере("СписокЗаказовНаПроизводство");
		
	Иначе
		Если ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.Изделие Тогда
			
			Заголовок = НСтр("ru = 'Изделия'");
			Для Каждого Строка Из ТаблицаОбъектов Цикл
				НоваяСтрока = СписокИзделий.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
				НоваяСтрока.Номенклатура = Строка.Объект;
			КонецЦикла;
			Элементы.СтраницыОбъектыКалькуляции.ТекущаяСтраница = Элементы.СтраницыОбъектыКалькуляции.ПодчиненныеЭлементы.СтраницаИзделие;
			
			ПараметрыЗаполненияРеквизитов = Новый Структура;
			ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
			НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(СписокИзделий, ПараметрыЗаполненияРеквизитов);
			
		КонецЕсли;
		
		Если ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.РесурснаяСпецификация Тогда
			
			Заголовок = НСтр("ru = 'Ресурсные спецификации'");
			Для Каждого Строка Из ТаблицаОбъектов Цикл
				ЗаполнитьЗначенияСвойств(СписокСпецификаций.Добавить(), Строка);
			КонецЦикла;
			Элементы.СтраницыОбъектыКалькуляции.ТекущаяСтраница = Элементы.СтраницыОбъектыКалькуляции.ПодчиненныеЭлементы.СтраницаСпецификация;
			
		КонецЕсли;
		
		Если ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.ЗаказНаПроизводство Тогда
			
			Заголовок = НСтр("ru = 'Позиции заказов на производство'");
			Для Каждого Строка Из ТаблицаОбъектов Цикл
				ЗаполнитьЗначенияСвойств(СписокЗаказовНаПроизводство.Добавить(), Строка);
			КонецЦикла;
			Элементы.СтраницыОбъектыКалькуляции.ТекущаяСтраница = Элементы.СтраницыОбъектыКалькуляции.ПодчиненныеЭлементы.СтраницаЗаказНаПроизводство;
			ОбновитьПредставленияНаСервере("СписокЗаказовНаПроизводство");
			
		КонецЕсли;
		
		ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Документ);
		
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ВыполняемаяОперация = "";
	Если ВыбранноеЗначение.Свойство("ВыполняемаяОперация", ВыполняемаяОперация) и ВыполняемаяОперация = "ВыборПозицииЗаказаНаПроизводство" Тогда
		
		Модифицированность = Истина;
		
		ЗначениеВыбора = ВыбранноеЗначение.ЗначениеВыбора;
		
		Если ВыбранноеЗначение.НоваяСтрока Тогда
			ТекущиеДанные = СписокЗаказовНаПроизводство.Добавить();
		Иначе
			ТекущиеДанные = Элементы.СписокЗаказовНаПроизводство.ТекущиеДанные;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ЗначениеВыбора);
		ОбновитьПредставленияНаСервере("СписокЗаказовНаПроизводство");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокИзделий

&НаКлиенте
Процедура СписокИзделийНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокИзделий.ТекущиеДанные;
	ТекущиеДанные.Номенклатура = ТекущиеДанные.Объект;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.Характеристика);

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "СписокИзделий"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИзделийПриИзменении(Элемент)
	
	НомерСтроки = 1;
	Для Каждого Строка Из СписокИзделий Цикл
		Строка.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокСпецификаций

&НаКлиенте
Процедура СписокСпецификацийПриИзменении(Элемент)
	ОбновитьПредставленияНаСервере("СписокСпецификаций");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗаказовНаПроизводство

&НаКлиенте
Процедура СписокЗаказовНаПроизводствоПриИзменении(Элемент)
	
	НомерСтроки = 1;
	Для Каждого Строка Из СписокЗаказовНаПроизводство Цикл
		Строка.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СписокЗаказовНаПроизводствоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура("НоваяСтрока, Документ", Истина, Документ);
		ОткрытьФорму("Документ.ПлановаяКалькуляция.Форма.ВыборПозицииЗаказаНаПроизводство", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗаказовНаПроизводствоПредставлениеПозицииЗаказаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура("НоваяСтрока, Документ", Ложь, Документ);
	ОткрытьФорму("Документ.ПлановаяКалькуляция.Форма.ВыборПозицииЗаказаНаПроизводство", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗаказовНаПроизводствоПредставлениеПозицииЗаказаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.СписокЗаказовНаПроизводство.ТекущиеДанные;
	ПоказатьЗначение(Неопределено, ТекущиеДанные.Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыборПозицииЗаказа

&НаКлиенте
Процедура СписокЗаказовНаПроизводство1ВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Модифицированность = Ложь;
	
	ТекущиеДанные = Элементы.СписокВыборПозицииЗаказа.ТекущиеДанные;
	
	ЗначениеВыбора = Новый Структура("ЗаказНаПроизводство, КодСтроки", ТекущиеДанные.Объект, ТекущиеДанные.КодСтрокиЗаказаНаПроизводство);
	
	СтруктураВыбора = Новый Структура();
	СтруктураВыбора.Вставить("Действие", Действие);
	СтруктураВыбора.Вставить("ЗначениеВыбора", ЗначениеВыбора);
	
	ОповеститьОВыборе(СтруктураВыбора);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Модифицированность Тогда
		
		Модифицированность = Ложь;
		
		СтруктураВыбора = Новый Структура();
		СтруктураВыбора.Вставить("Действие", Действие);
		СтруктураВыбора.Вставить("ЗначениеВыбора", РезультатРедактированияНаСервере());
		
		ОповеститьОВыборе(СтруктураВыбора);
		
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "СписокИзделийХарактеристика",
																		     "СписокИзделий.ХарактеристикиИспользуются");
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокИзделийХарактеристика.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокИзделий.ХарактеристикиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокИзделий.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеактуальногоСписка);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<любая характеристика>'"));	
	
КонецПроцедуры

&НаСервере
Функция РезультатРедактированияНаСервере()
	
	Перем ЕдиницаИзмерения;
	
	Если ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.Изделие Тогда
		Для Каждого Строка Из СписокИзделий Цикл
			НоваяСтрока = ДействиеКалькуляции.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.ИспользоватьХарактеристику = ЗначениеЗаполнено(Строка.Характеристика);
			ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.Объект, "ЕдиницаИзмерения");
		КонецЦикла;
	КонецЕсли;
	
	Если ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.РесурснаяСпецификация Тогда
		Для Каждого Строка Из СписокСпецификаций Цикл
			ЗаполнитьЗначенияСвойств(ДействиеКалькуляции.Добавить(), Строка);
		КонецЦикла;
	КонецЕсли;
	
	Если ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.ЗаказНаПроизводство Тогда
		Для Каждого Строка Из СписокЗаказовНаПроизводство Цикл
			ЗаполнитьЗначенияСвойств(ДействиеКалькуляции.Добавить(), Строка);
		КонецЦикла;
	КонецЕсли;
	
	РезультатРедактирования = Новый Структура("ДействиеКалькуляции, ЕдиницаИзмерения",
		ДействиеКалькуляции.Выгрузить(), ЕдиницаИзмерения);
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(РезультатРедактирования);
	
	Возврат АдресВХранилище;
	
КонецФункции

&НаСервере
Процедура ОбновитьПредставленияНаСервере(ИмяКоллекции)
	
	Документы.ПлановаяКалькуляция.ЗаполнитьПредставленияОбъектовКалькуляции(
		ЭтаФорма[ИмяКоллекции],
		ОбъектКалькуляции);
	
	НомерСтроки = 1;
	Для Каждого Строка Из ЭтаФорма[ИмяКоллекции] Цикл
		Строка.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

