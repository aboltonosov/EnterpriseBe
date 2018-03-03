﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УникальныйИдентфикаторФормыДокументаУстановкаЦенНоменклатуры = Параметры.УникальныйИдентификатор;
	АдресДанныеДляПечатиВоВременномХранилище = Параметры.АдресДанныеДляПечатиВоВременномХранилище;
	
	ДанныеДляПечати = Неопределено;
	Если ЗначениеЗаполнено(АдресДанныеДляПечатиВоВременномХранилище) Тогда
		ДанныеДляПечати = ПолучитьИзВременногоХранилища(АдресДанныеДляПечатиВоВременномХранилище);
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыЦен.Ссылка            КАК Ссылка,
	|	ВидыЦен.Наименование      КАК Наименование,
	|	ВидыЦен.СпособЗаданияЦены КАК СпособЗаданияЦены,
	|	ВЫБОР
	|		КОГДА
	|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.Вручную)
	|		ТОГДА
	|			0
	|		КОГДА
	|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ)
	|		ТОГДА
	|			1
	|		КОГДА
	|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.РассчитыватьПоФормуламОтДругихВидовЦен)
	|		ТОГДА
	|			2
	|	КОНЕЦ КАК ИндексКартинки
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.Ссылка В(&МассивВидовЦен)
	|УПОРЯДОЧИТЬ ПО
	|	ВидыЦен.РеквизитДопУпорядочивания
	|";
	
	Если ДанныеДляПечати = Неопределено Тогда
		Запрос.УстановитьПараметр("МассивВидовЦен", ВидыЦенДокументов(Параметры.МассивДокументов));
	Иначе
		Запрос.УстановитьПараметр("МассивВидовЦен", ДанныеДляПечати.ВидыЦен);
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаВидЦены = ДеревоНастроек.ПолучитьЭлементы().Добавить();
		НоваяСтрокаВидЦены.Наименование  = Выборка.Наименование;
		НоваяСтрокаВидЦены.Параметр = Выборка.Ссылка;
		НоваяСтрокаВидЦены.ИндексКартинки = Выборка.ИндексКартинки;
		НоваяСтрокаВидЦены.ВыводитьНаПечать = 1;
		
		НоваяСтрокаКолонка = НоваяСтрокаВидЦены.ПолучитьЭлементы().Добавить();
		НоваяСтрокаКолонка.Наименование = НСтр("ru = 'Старая цена'");
		НоваяСтрокаКолонка.Параметр = "СтараяЦена";
		НоваяСтрокаКолонка.ИндексКартинки = -1;
		НоваяСтрокаКолонка.ВыводитьНаПечать = 1;
		
		НоваяСтрокаКолонка = НоваяСтрокаВидЦены.ПолучитьЭлементы().Добавить();
		НоваяСтрокаКолонка.Наименование = НСтр("ru = 'Сумма изменения'");
		НоваяСтрокаКолонка.Параметр = "СуммаИзменения";
		НоваяСтрокаКолонка.ИндексКартинки = -1;
		НоваяСтрокаКолонка.ВыводитьНаПечать = 1;
		
		НоваяСтрокаКолонка = НоваяСтрокаВидЦены.ПолучитьЭлементы().Добавить();
		НоваяСтрокаКолонка.Наименование = НСтр("ru = 'Процент изменения'");
		НоваяСтрокаКолонка.Параметр = "ПроцентИзменения";
		НоваяСтрокаКолонка.ИндексКартинки = -1;
		НоваяСтрокаКолонка.ВыводитьНаПечать = 1;
		
	КонецЦикла;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоНастроек

&НаКлиенте
Процедура ДеревоНастроекВыводитьНаПечатьПриИзменении(Элемент)
	
	ТекущаяСтрока = ДеревоНастроек.НайтиПоИдентификатору(Элементы.ДеревоНастроек.ТекущаяСтрока);
	Если ТипЗнч(ТекущаяСтрока.Параметр) = Тип("СправочникСсылка.ВидыЦен") Тогда
		
		Если ТекущаяСтрока.ВыводитьНаПечать = 2 Тогда
			ТекущаяСтрока.ВыводитьНаПечать = 0;
		КонецЕсли;
		
	Иначе
		
		Если ТекущаяСтрока.ВыводитьНаПечать = 2 Тогда
			ТекущаяСтрока.ВыводитьНаПечать = 0;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ДеревоНастроек", ПоместитьВоВременноеХранилищеНаСервере());
	ПараметрыПечати.Вставить("ДеревоНастроекДляКлиента", ПоместитьВоВременноеХранилищеНаСервереДляКлиента());
	ПараметрыПечати.Вставить("ПечататьТолькоИзмененныеЦены", ТолькоИзмененныеЦены);
	ПараметрыПечати.Вставить("ВыводитьШапку", Истина);
	ПараметрыПечати.Вставить("АдресДанныеДляПечатиВоВременномХранилище", АдресДанныеДляПечатиВоВременномХранилище);
	
	Закрыть(ПараметрыПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенВыбратьВсе(Команда)
	
	Для Каждого ВидЦены Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		ВидЦены.ВыводитьНаПечать = 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенИсключитьВсе(Команда)
	
	Для Каждого ВидЦены Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		ВидЦены.ВыводитьНаПечать = 0;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция ВидыЦенДокументов(МассивДокументов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УстановкаЦенНоменклатурыВидыЦен.ВидЦены КАК ВидЦены
	|ИЗ
	|	Документ.УстановкаЦенНоменклатуры.ВидыЦен КАК УстановкаЦенНоменклатурыВидыЦен
	|ГДЕ
	|	УстановкаЦенНоменклатурыВидыЦен.Ссылка В(&МассивДокументов)";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидЦены");
	
КонецФункции

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервереДляКлиента()
	
	Массив = Новый Массив;
	
	Дерево = ДанныеФормыВЗначение(ДеревоНастроек, Тип("ДеревоЗначений"));
	Для Каждого Строка Из Дерево.Строки Цикл
		
		НоваяСтрока = Новый Структура("Наименование, ВыводитьНаПечать, Параметр, Строки");
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, , "Строки");
		НоваяСтрока.Строки = Новый Массив;
		
		Для Каждого Строка2Уровень Из Строка.Строки Цикл
			НоваяСтрока2Уровень = Новый Структура("Наименование, ВыводитьНаПечать, Параметр");
			ЗаполнитьЗначенияСвойств(НоваяСтрока2Уровень, Строка2Уровень);
			НоваяСтрока.Строки.Добавить(НоваяСтрока2Уровень);
		КонецЦикла;
		
		Массив.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(Новый Структура("Строки", Массив), УникальныйИдентфикаторФормыДокументаУстановкаЦенНоменклатуры);
	
КонецФункции

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Дерево = ДанныеФормыВЗначение(ДеревоНастроек, Тип("ДеревоЗначений"));
	Возврат ПоместитьВоВременноеХранилище(Дерево, УникальныйИдентфикаторФормыДокументаУстановкаЦенНоменклатуры);
	
КонецФункции

#КонецОбласти

#КонецОбласти
