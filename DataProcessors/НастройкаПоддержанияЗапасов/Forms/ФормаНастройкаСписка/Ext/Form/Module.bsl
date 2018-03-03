﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если Параметры.АдресНастроекКомпоновкиДанных <> "" Тогда
		КомпоновщикНастроек.Инициализировать(
			Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.АдресСхемыКомпоновкиДанных));
		
		ПользовательскиеНастройки = ПолучитьИзВременногоХранилища(Параметры.АдресНастроекКомпоновкиДанных);
		
		Элементы.НастройкиОтбора.Видимость				= Ложь;
		Элементы.НастройкиПорядка.Видимость				= Ложь;
		Элементы.НастройкиУсловногоОформления.Видимость	= Ложь;
		Элементы.НастройкаГруппировки.Видимость			= Ложь;
		
		Для каждого ЭлементНастройки Из ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ОтборКомпоновкиДанных") Тогда
				КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки =
					ЭлементНастройки.ИдентификаторПользовательскойНастройки;
				Элементы.НастройкиОтбора.Видимость				= Истина;
			ИначеЕсли ТипЗнч(ЭлементНастройки) = Тип("ПорядокКомпоновкиДанных") Тогда
				КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки =
					ЭлементНастройки.ИдентификаторПользовательскойНастройки;
				Элементы.НастройкиПорядка.Видимость				= Истина;
			ИначеЕсли ТипЗнч(ЭлементНастройки) = Тип("УсловноеОформлениеКомпоновкиДанных") Тогда
				КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки =
					ЭлементНастройки.ИдентификаторПользовательскойНастройки;
				Элементы.НастройкиУсловногоОформления.Видимость	= Истина;
			ИначеЕсли ТипЗнч(ЭлементНастройки) = Тип("СтруктураНастроекКомпоновкиДанных") Тогда
				КомпоновщикНастроек.Настройки.Структура.ИдентификаторПользовательскойНастройки =
					ЭлементНастройки.ИдентификаторПользовательскойНастройки;
				Элементы.НастройкаГруппировки.Видимость			= Истина;
			КонецЕсли;
			Если Элементы.Структура.ТекущаяСтрока = Неопределено Тогда
				Элементы.Структура.ТекущаяСтрока =
					КомпоновщикНастроек.ПользовательскиеНастройки.ПолучитьИдентификаторПоОбъекту(ЭлементНастройки);
			КонецЕсли;
		КонецЦикла;
		
		КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(
			ПолучитьИзВременногоХранилища(Параметры.АдресНастроекКомпоновкиДанных));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипыНастроекПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.НастройкиОтбора Тогда
		НужныйТип = Тип("ОтборКомпоновкиДанных");
	ИначеЕсли ТекущаяСтраница = Элементы.НастройкиПорядка Тогда
		НужныйТип = Тип("ПорядокКомпоновкиДанных");
	ИначеЕсли ТекущаяСтраница = Элементы.НастройкиУсловногоОформления Тогда
		НужныйТип = Тип("УсловноеОформлениеКомпоновкиДанных");
	ИначеЕсли ТекущаяСтраница = Элементы.НастройкаГруппировки Тогда
		НужныйТип = Тип("СтруктураНастроекКомпоновкиДанных");
	КонецЕсли;
	
	Для каждого ЭлементНастройки Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастройки) = НужныйТип Тогда
			Элементы.Структура.ТекущаяСтрока =
				КомпоновщикНастроек.ПользовательскиеНастройки.ПолучитьИдентификаторПоОбъекту(ЭлементНастройки);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	//Закрыть(ПолучитьНастрокиКомпоновщика(КомпоновщикНастроек, ВладелецФормы.УникальныйИдентификатор));
	Закрыть(ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПользовательскиеНастройки,
		ВладелецФормы.УникальныйИдентификатор));
КонецПроцедуры

#КонецОбласти